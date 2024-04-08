import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../permit_applications.dart';

class PermitApplicationsView extends StatelessWidget {
  const PermitApplicationsView({
    Key? key,
    this.status,
  }) : super(key: key);

  final PermitApplicationStatusEnum? status;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitApplicationsCubit>();
    var theme = Theme.of(context);
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
              vertical: ResponsiveWidget.mediumPadding(context),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Applications",
                      style: theme.textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_alt),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
