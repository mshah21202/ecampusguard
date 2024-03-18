import 'package:ecampusguard/features/login/view/login_page.dart';
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
    )
  ],
);
