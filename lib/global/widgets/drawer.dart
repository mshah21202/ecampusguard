import 'package:ecampusguard/features/authentication/authentication.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Text(
              'eCampusGuard',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.pop();
              context.go(homeRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('Permit'),
            onTap: () {
              context.pop();
              context.go("$homeRoute$userPermitDetailsRoute");
            },
          ),
          ListTile(
            leading: const Icon(Icons.apps),
            title: const Text('Applications'),
            onTap: () {
              context.pop();
              context.go("$homeRoute$userApplicationsRoute");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              var cubit = context.read<AuthenticationCubit>();
              cubit.logout();
            },
          ),
        ],
      ),
    );
  }
}
