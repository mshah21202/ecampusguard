import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AdminAppDrawer extends StatelessWidget {
  const AdminAppDrawer({
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
              context.go(adminHomeRoute);
            },
          ),
          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('Permits'),
            onTap: () {
              context.pop();
              context.go("$adminHomeRoute/$adminPermitsRoute");
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: const Text('Areas'),
            onTap: () {
              context.pop();
              context.go("$adminHomeRoute/$adminAreasRoute");
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text('User Permits'),
            onTap: () {
              context.pop();
              context.go("$adminHomeRoute/$adminUserPermitsRoute");
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Applications'),
            onTap: () {
              context.pop();
              context.go("$adminHomeRoute/$adminApplicationsRoute");
            },
          ),
          ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Update Requests'),
              onTap: () {
                context.pop();
                context.go("$adminHomeRoute/$adminUpdateRequestDetailsRoute");
              }),
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
