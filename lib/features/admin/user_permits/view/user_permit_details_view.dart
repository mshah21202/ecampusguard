import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
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
    // var theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      drawer: const AdminAppDrawer(),
      body: const Stack(
        fit: StackFit.expand,
        children: [
          BackgroundLogo(),
        ],
      ),
    );
  }
}
