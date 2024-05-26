import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApplicationSummary extends StatelessWidget {
  const ApplicationSummary({
    super.key,
    required this.applicationSummary,
  });

  final ApplicationSummaryDto applicationSummary;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.brightness == Brightness.light
                  ? theme.colorScheme.shadow.withOpacity(0.25)
                  : theme.colorScheme.secondaryContainer.withOpacity(0.5),
              blurRadius: 15.0,
            )
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    applicationSummary.title ?? "",
                    style: theme.textTheme.headlineSmall!
                        .copyWith(color: theme.colorScheme.onBackground),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Icon(
                    IconData(
                      int.parse(applicationSummary.icon ?? "0"),
                      fontFamily: 'MaterialIcons',
                    ),
                    size: 32,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                )
              ],
            ),
            Text(
              (applicationSummary.count ?? 0).toString(),
              style: theme.textTheme.displaySmall!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            FilledButton(
              onPressed: () {
                GoRouter.of(context).go(
                    "$adminHomeRoute/$adminApplicationsRoute?${applicationSummary.route}");
              },
              child: const Text("Review Now"),
            )
          ].addElementBetweenElements(
            const SizedBox(
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
