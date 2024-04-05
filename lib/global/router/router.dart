import 'package:ecampusguard/features/apply_for_permit/view/apply_for_permit_page.dart';
import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/login/view/login_page.dart';
import 'package:ecampusguard/features/home/view/home_page.dart';
import 'package:ecampusguard/features/register/register.dart';
import 'package:ecampusguard/global/extensions/go_router_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter({
  required AuthenticationCubit authCubit,
}) =>
    GoRouter(
      initialLocation: loginRoute,
      refreshListenable: GoRouterRefreshStream(
          authCubit.stream, (state) => state is! LoadingAuthentication),
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
        ),
        GoRoute(
          path: applyForPermitRoute,
          builder: (context, state) {
            return const ApplyForPermitPage();
          },
        ),
        GoRoute(
          path: registerRoute,
          builder: (context, state) {
            return const RegisterPage();
          },
        ),
      ],
      redirect: (context, state) async {
        var loggedIn = authCubit.isValidSession();
        var loggingIn = state.matchedLocation == loginRoute ||
            state.matchedLocation == registerRoute;
        if (!loggedIn) {
          if (loggingIn || state.matchedLocation == registerRoute) {
            return null;
          }

          return loginRoute;
        }

        if (loggingIn) {
          return homeRoute;
        }
        return null;
      },
    );
