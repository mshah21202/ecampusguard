import 'package:dio/dio.dart';
import 'package:ecampusguard/features/authentication/authentication.dart';
import 'package:ecampusguard/firebase_options.dart';
import 'package:ecampusguard/global/router/router.dart';
import 'package:ecampusguard/global/services/phone_number_validator.dart';
import 'package:ecampusguard/global/theme/cubit/theme_cubit.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  var getIt = GetIt.instance;
  var api = Ecampusguardapi(
    dio: Dio(
      BaseOptions(
        baseUrl: "https://ecampusguardapi-the7i2jl6q-ez.a.run.app",
        // baseUrl: "http://0.0.0.0:8080",
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 150),
      ),
    ),
  );
  var phoneNumberValidator = PhoneNumberValidator();
  var prefs = await SharedPreferences.getInstance();
  setPathUrlStrategy();
  getIt.registerSingleton<Ecampusguardapi>(api);
  getIt.registerSingleton<PhoneNumberValidator>(phoneNumberValidator);
  getIt.registerSingleton<SharedPreferences>(prefs);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationCubit()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp.router(
            builder: (context, child) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                var themeCubit = context.read<ThemeCubit>();
                return Theme(
                    data: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: const Color(0xFF000055),
                        brightness: themeCubit.darkMode
                            ? Brightness.dark
                            : Brightness.light,
                      ),
                      useMaterial3: false,
                      inputDecorationTheme: InputDecorationTheme(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outline),
                        ),
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          minimumSize: MaterialStateProperty.all(
                            const Size(32, 52),
                          ),
                        ),
                      ),
                      filledButtonTheme: FilledButtonThemeData(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            const Size(32, 52),
                          ),
                        ),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          minimumSize: MaterialStateProperty.all(
                            const Size(32, 52),
                          ),
                        ),
                      ),
                    ),
                    child: child ?? const Center());
              });
            },
            title: 'ecampusguard',
            debugShowCheckedModeBanner: false,
            routerConfig:
                appRouter(authCubit: context.read<AuthenticationCubit>()));
      }),
    );
  }
}
