import 'package:ecampusguard/features/authentication/authentication.dart';
import 'package:ecampusguard/features/login/login.dart';
import 'package:ecampusguard/global/router/router.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  var getIt = GetIt.instance;
  var api = Ecampusguardapi(basePathOverride: "https://localhost:7163");
  setPathUrlStrategy();
  getIt.registerSingleton<Ecampusguardapi>(api);

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
          ),
          title: 'ecampusguard',
          debugShowCheckedModeBanner: false,
          routerConfig: ecampusguard_router),
    );
  }
}
