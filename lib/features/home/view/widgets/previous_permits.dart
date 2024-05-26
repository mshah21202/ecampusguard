import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/home/cubit/home_cubit.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PreviousPermits extends StatelessWidget {
  const PreviousPermits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var permits = context.read<HomeCubit>().previousPermits;
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border.all(
                color: theme.colorScheme.outlineVariant,
                strokeAlign: BorderSide.strokeAlignOutside),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: theme.colorScheme.surfaceVariant,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Previous Permits",
                  style: theme.textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              permits.isNotEmpty
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: permits.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          dense: false,
                          title: Text(permits[index].permit?.name ?? ""),
                          subtitle: Text(
                            "Expiry: ${DateFormat("dd/MM/yyy").format(permits[index].expiry!)}",
                          ),
                          trailing: UserPermitStatusChip(
                              status: permits[index].status!),
                        );
                      },
                    )
                  : Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          vertical: ResponsiveWidget.largePadding(context)),
                      child: Text(
                        "You don't have any previous permits",
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}
