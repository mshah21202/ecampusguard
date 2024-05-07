import 'dart:math';

import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AccessLogsList extends StatelessWidget {
  const AccessLogsList({
    super.key,
    required this.accessLogs,
    this.showPlateNumber = false,
    this.showEmpty = false,
  });

  final List<AccessLogDto> accessLogs;
  final bool showPlateNumber;
  final bool showEmpty;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Entry/Exit Logs",
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          !accessLogs.isEmptyOrNull
              ? ListView.separated(
                  shrinkWrap: true,
                  itemCount: !accessLogs.isEmptyOrNull
                      ? (showEmpty ? 4 : min(4, accessLogs.length))
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < accessLogs.length) {
                      return ListTile(
                        leading:
                            accessLogs[index].logType == AccessLogType.Entry
                                ? Icon(
                                    Icons.login,
                                    color: theme.colorScheme.primary,
                                  )
                                : Icon(
                                    Icons.logout,
                                    color: theme.colorScheme.error,
                                  ),
                        subtitle: Text(
                          DateFormat("dd/MM/y h:m a")
                              .format(accessLogs[index].timestamp!),
                        ),
                        title: Text(
                          showPlateNumber
                              ? accessLogs[index].licensePlate!
                              : accessLogs[index].permitName!,
                        ),
                      );
                    } else {
                      return const ListTile(
                        title: Text(""),
                        subtitle: Text(""),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: theme.colorScheme.outlineVariant);
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Text(
                    "No logs yet",
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
        ],
      ),
    );
  }
}
