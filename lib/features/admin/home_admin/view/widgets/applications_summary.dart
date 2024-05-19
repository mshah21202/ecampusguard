import 'package:ecampusguard/features/admin/home_admin/cubit/home_admin_cubit.dart';
import 'package:ecampusguard/features/admin/home_admin/view/widgets/application_summary.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ApplicationsSummary extends StatelessWidget {
  const ApplicationsSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAdminCubit, HomeAdminState>(
        buildWhen: (previous, current) => (current is HomeAdminLoaded &&
            current.applicationSummaries != null),
        builder: (context, state) {
          var theme = Theme.of(context);
          var cubit = context.read<HomeAdminCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Applications Summary",
                    style: theme.textTheme.headlineMedium!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      context.go("$adminHomeRoute/$adminApplicationsRoute");
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              !ResponsiveWidget.isSmallScreen(context)
                  ? Row(
                      children: cubit.applicationSummaries
                          .map<Widget>((s) => ApplicationSummary(
                                applicationSummary: s,
                              ))
                          .toList()
                          .addElementBetweenElements(
                            SizedBox(
                              width: ResponsiveWidget.smallPadding(context),
                            ),
                          ),
                    )
                  : IntrinsicHeight(
                      child: Column(
                        children: cubit.applicationSummaries
                            .map<Widget>((s) => ApplicationSummary(
                                  applicationSummary: s,
                                ))
                            .toList()
                            .addElementBetweenElements(
                              SizedBox(
                                height: ResponsiveWidget.smallPadding(context),
                              ),
                            ),
                      ),
                    )
            ],
          );
        });
  }
}
