import 'package:ecampusguard/features/home/home.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AccessLogsList extends StatelessWidget {
  const AccessLogsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        var theme = Theme.of(context);
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  "Entry/Exit Logs",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: cubit.userPermit != null
                    ? !cubit.userPermit!.accessLogs.isEmptyOrNull
                        ? 4
                        : 0
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: cubit.userPermit!.accessLogs![index].logType ==
                            AccessLogType.Entry
                        ? Icon(
                            Icons.login,
                            color: theme.colorScheme.primary,
                          )
                        : Icon(
                            Icons.logout,
                            color: theme.colorScheme.error,
                          ),
                    subtitle: Text(DateFormat("dd/MM/y h:m a").format(
                        cubit.userPermit!.accessLogs![index].timestamp!)),
                    title: Text(
                      cubit.userPermit!.permit!.area!.gate!,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(color: theme.colorScheme.outlineVariant);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
