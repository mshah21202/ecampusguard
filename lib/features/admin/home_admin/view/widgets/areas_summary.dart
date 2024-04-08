import 'package:ecampusguard/features/admin/home_admin/cubit/home_admin_cubit.dart';
import 'package:ecampusguard/features/admin/home_admin/view/widgets/area_summary.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AreasSummary extends StatelessWidget {
  const AreasSummary({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cubit = context.read<HomeAdminCubit>();
    return BlocBuilder<HomeAdminCubit, HomeAdminState>(
        buildWhen: (previous, current) =>
            current is HomeAdminLoaded && current.areaSummaries != null,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Areas Summary",
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: cubit.areaSummaries
                    .map<Widget>(
                      (e) => AreaSummary(areaSummary: e),
                    )
                    .toList()
                    .addElementBetweenElements(
                      SizedBox(
                        width: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
              )
            ],
          );
        });
  }
}
