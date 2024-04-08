import 'package:ecampusguard/features/admin/home_admin/view/widgets/applications_summary.dart';
import 'package:ecampusguard/features/admin/home_admin/view/widgets/areas_summary.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_admin.dart';

class HomeAdminView extends StatelessWidget {
  const HomeAdminView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final cubit = context.read<HomeAdminCubit>();
    return Scaffold(
      appBar: appBar,
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveWidget.defaultPadding(context),
              vertical: ResponsiveWidget.smallPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ApplicationsSummary(),
                const AreasSummary(),
              ].addElementBetweenElements(
                SizedBox(
                  height: ResponsiveWidget.defaultPadding(context),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}