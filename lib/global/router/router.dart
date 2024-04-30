import 'package:ecampusguard/features/admin/areas/areas.dart';
import 'package:ecampusguard/features/admin/home_admin/view/home_admin_page.dart';
import 'package:ecampusguard/features/admin/permit_applications/permit_applications.dart';
import 'package:ecampusguard/features/admin/permits/permits.dart';
import 'package:ecampusguard/features/admin/permits/view/permit_details_view.dart';
import 'package:ecampusguard/features/admin/user_permits/user_permits.dart';
import 'package:ecampusguard/features/apply_for_permit/view/apply_for_permit_page.dart';
import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/login/view/login_page.dart';
import 'package:ecampusguard/features/home/view/home_page.dart';
import 'package:ecampusguard/features/register/register.dart';
import 'package:ecampusguard/features/user_permit_details/user_permit_details.dart';
import 'package:ecampusguard/global/extensions/go_router_extension.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/helpers/user_permits_params.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            GoRoute(
              path: userPermitDetailsRoute,
              builder: (context, state) {
                return const UserPermitDetailsPage();
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
            ShellRoute(
              builder: (context, state, child) {
                PermitApplicationsParams params =
                    PermitApplicationsParams.fromUri(state.uri);
                return BlocProvider(
                  create: (_) => PermitApplicationsCubit(params: params),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: adminApplicationsRoute,
                  builder: (context, state) {
                    return const PermitApplicationsListView();
                  },
                  routes: [
                    GoRoute(
                      path: adminApplicationDetailsRoute,
                      builder: (context, state) {
                        int id = int.parse(state.pathParameters["id"]!);
                        return PermitApplicationDetailsView(applicationId: id);
                      },
                    )
                  ],
                ),
              ],
            ),
            ShellRoute(
              builder: (context, state, child) {
                return BlocProvider(
                  create: (_) => AreasCubit(),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: adminAreasRoute,
                  builder: (context, state) {
                    return const AreasListView();
                  },
                  routes: [
                    GoRoute(
                      path: adminAreaDetailsRoute,
                      builder: (context, state) {
                        int? id =
                            int.tryParse(state.pathParameters["id"] ?? "");
                        return AreaDetailsView(areaId: id);
                      },
                    ),
                    GoRoute(
                      path: adminCreateAreaRoute,
                      builder: (context, state) {
                        return const AreaDetailsView();
                      },
                    ),
                  ],
                ),
              ],
            ),
            ShellRoute(
              builder: (context, state, child) {
                return BlocProvider(
                  create: (_) => PermitsCubit(),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: adminPermitsRoute,
                  builder: (context, state) {
                    return const PermitsListView();
                  },
                  routes: [
                    GoRoute(
                      path: adminPermitDetailsRoute,
                      builder: (context, state) {
                        int? id =
                            int.tryParse(state.pathParameters["id"] ?? "");
                        return PermitDetailsView(permitId: id);
                      },
                    ),
                    GoRoute(
                      path: adminCreatePermitRoute,
                      builder: (context, state) {
                        return const PermitDetailsView();
                      },
                    ),
                  ],
                ),
              ],
            ),
            ShellRoute(
              builder: (context, state, child) {
                UserPermitsParams params = UserPermitsParams.fromUri(state.uri);
                return BlocProvider(
                  create: (_) => UserPermitsCubit(params: params),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  path: adminUserPermitsRoute,
                  builder: (context, state) {
                    return const UserPermitsListView();
                  },
                  routes: [
                    GoRoute(
                      path: adminUserPermitDetailsRoute,
                      builder: (context, state) {
                        int? id =
                            int.tryParse(state.pathParameters["id"] ?? "");
                        return UserPermitDetailsView(
                          permitId: id!,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        )
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
