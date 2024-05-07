import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AreaScreenSummary extends StatelessWidget {
  const AreaScreenSummary({
    super.key,
    required this.areaScreen,
  });

  final AreaScreenDto areaScreen;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      constraints: BoxConstraints(
        maxWidth: !ResponsiveWidget.isSmallScreen(context)
            ? (MediaQuery.of(context).size.width * 0.2964)
            : double.infinity,
      ),
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
        children: <Widget>[
          Text(
            "${areaScreen.name!} Area",
            style: theme.textTheme.headlineSmall!
                .copyWith(color: theme.colorScheme.onBackground),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                (areaScreen.occupied ?? 0).toString(),
                style: theme.textTheme.headlineLarge!
                    .copyWith(color: theme.colorScheme.onBackground),
              ),
              Text(
                " /${(areaScreen.capacity ?? 0).toString()}",
                style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.onBackground.withOpacity(0.5)),
              ),
            ],
          ),
          FilledButton(
            onPressed: () {
              context.go(
                  "$gateStaffHomeRoute/$gateStaffAreaScreenRoute/${areaScreen.id}");
            },
            child: const Text("Access Area"),
          ),
        ].addElementBetweenElements(
          const SizedBox(
            height: 24,
          ),
        ),
      ),
    );
  }
}
