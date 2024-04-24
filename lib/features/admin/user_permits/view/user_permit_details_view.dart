import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:flutter/material.dart';

class UserPermitDetailsView extends StatelessWidget {
  const UserPermitDetailsView({
    Key? key,
    required this.permitId,
  }) : super(key: key);

  final int permitId;

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<UserPermitsCubit>();
    var theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      drawer: const AdminAppDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: -150,
            bottom: -150,
            child: Opacity(
              opacity: 0.2,
              child: AppLogo(
                darkMode: theme.colorScheme.brightness == Brightness.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
