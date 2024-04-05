import 'package:ecampusguard/features/authentication/authentication.dart';
import 'package:ecampusguard/features/login/login.dart';
import 'package:ecampusguard/global/router/router.dart';
import 'package:ecampusguard/global/services/phone_number_validator.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var getIt = GetIt.instance;
  var api = Ecampusguardapi(
      basePathOverride:
          "https://0685fb90-1c5f-44e6-b91e-b7c7d126453b.mock.pstmn.io");
  var phoneNumberValidator = PhoneNumberValidator();
  setPathUrlStrategy();
  getIt.registerSingleton<Ecampusguardapi>(api);
  getIt.registerSingleton<PhoneNumberValidator>(phoneNumberValidator);

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
      ],
      child: MaterialApp.router(
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFF000055)),
            useMaterial3: false,
            inputDecorationTheme: InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const StadiumBorder()),
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
                minimumSize: MaterialStateProperty.all(
                  const Size(32, 52),
                ),
              ),
            ),
          ),
          title: 'ecampusguard',
          debugShowCheckedModeBanner: false,
          routerConfig: ecampusguard_router),
    );
  }
}
