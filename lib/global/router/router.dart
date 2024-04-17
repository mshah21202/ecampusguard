import 'package:ecampusguard/features/admin/applications_review/applications_review.dart';
import 'package:ecampusguard/features/admin/home_admin/view/home_admin_page.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/permit_applications_page.dart';
import 'package:ecampusguard/features/apply_for_permit/view/apply_for_permit_page.dart';
import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/login/view/login_page.dart';
import 'package:ecampusguard/features/home/view/home_page.dart';
import 'package:ecampusguard/features/register/register.dart';
import 'package:ecampusguard/global/extensions/go_router_extension.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
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
          path: registerRoute,
          builder: (context, state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          // User routes
          path: homeRoute,
          builder: (context, state) {
            return const HomePage();
          },
          redirect: (context, state) {
            switch (authCubit.role) {
              case Role.user:
                return null;
              case Role.admin:
                return adminHomeRoute;
              default:
                return homeRoute;
            }
          },
          routes: [
            GoRoute(
              path: applyForPermitRoute,
              builder: (context, state) {
                return const ApplyForPermitPage();
              },
            ),
          ],
        ),
        GoRoute(
            path: adminHomeRoute,
            redirect: (context, state) {
              switch (authCubit.role) {
                case Role.user:
                  return homeRoute;
                case Role.admin:
                  return null;
                default:
                  return homeRoute;
              }
            },
            builder: (context, state) {
              return const HomeAdminPage();
            },
            routes: [
              GoRoute(
                  path: adminApplicationsRoute,
                  builder: (context, state) {
                    PermitApplicationsParams params =
                        PermitApplicationsParams.fromUri(state.uri);

                    return PermitApplicationsPage(
                      params: params,
                    );
                  },
                  routes: [
                    GoRoute(
                      path: adminApplicationReviewRoute,
                      builder: (context, state) {
                        int id = int.parse(state.pathParameters["id"]!);
                        return ApplicationsReviewPage(applicationId: id);
                      },
                    )
                  ]),
            ])
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
          switch (authCubit.role) {
            case Role.user:
              return homeRoute;
            case Role.admin:
              return adminHomeRoute;
            default:
              return homeRoute;
          }
        }
        return null;
      },
    );
