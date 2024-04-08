import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class AreaSummary extends StatelessWidget {
  const AreaSummary({super.key, required this.areaSummary});

  final AreaDto areaSummary;

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
            ]),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              areaSummary.name ?? "",
              style: theme.textTheme.headlineSmall!
                  .copyWith(color: theme.colorScheme.onBackground),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  (areaSummary.occupied ?? 0).toString(),
                  style: theme.textTheme.headlineLarge!
                      .copyWith(color: theme.colorScheme.onBackground),
                ),
                Text(
                  " /${(areaSummary.capacity ?? 0).toString()}",
                  style: theme.textTheme.headlineSmall!.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.5)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
