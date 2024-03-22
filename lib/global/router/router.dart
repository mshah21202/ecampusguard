import 'package:ecampusguard/features/home/view/home_view.dart';
import 'package:ecampusguard/features/login/view/login_page.dart';
import 'package:ecampusguard/features/home/view/home_page.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:go_router/go_router.dart';

GoRouter ecampusguard_router = GoRouter(
  initialLocation: loginRoute,
  routes: [
    GoRoute(
      path: loginRoute,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: homeRoute,
      builder: (context, state) {
        return const HomePage();
      },
    )
  ],
);
