import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/features/gatestaff/area_screen/view/widgets/live_feed_status_chip.dart';
import 'package:ecampusguard/features/gatestaff/area_screen/view/widgets/search_dialog.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/raw_status_chip.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class AnplrWidget extends StatelessWidget {
  const AnplrWidget({
    super.key,
    required this.anplrResult,
    required this.connected,
    required this.onRefresh,
    bool? connecting,
  }) : _connecting = connecting ?? !connected;

  final AnplrResultDto? anplrResult;
  final void Function() onRefresh;
  final bool connected;
  final bool _connecting;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Widget> titleAndStatus = <Widget>[
      Text(
        "Automatic Number Plate Reader",
        style: theme.textTheme.headlineSmall!.copyWith(
          color: theme.colorScheme.onBackground,
        ),
      ),
      LiveFeedStatusChip(
        connected: connected,
        connecting: _connecting,
        onRefresh: onRefresh,
      ),
    ];

    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveWidget.mediumPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (!ResponsiveWidget.isSmallScreen(context))
                ? Row(
                    children: titleAndStatus.addElementBetweenElements(
                      SizedBox(
                        width: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
                  )
                : UnconstrainedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: titleAndStatus.addElementBetweenElements(
                        SizedBox(
                          height: ResponsiveWidget.smallPadding(context),
                        ),
                      ),
                    ),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Wrap(
                  // alignment: WrapAlignment.start,
                  // runAlignment: WrapAlignment.start,
                  // crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: ResponsiveWidget.xLargePadding(context),
                  runSpacing: ResponsiveWidget.xLargePadding(context),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "License Plate Number",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          anplrResult != null ? anplrResult!.plateNumber! : "-",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Allowed to Enter",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RawStatusChip(
                          label: anplrResult != null
                              ? (anplrResult!.allowedToEnter! ? "Yes" : "No")
                              : "N/A",
                          leadingIcon: anplrResult != null
                              ? (anplrResult!.allowedToEnter!
                                  ? Icons.check_circle
                                  : Icons.cancel)
                              : Icons.pending,
                          backgroundColor: anplrResult != null
                              ? (anplrResult!.allowedToEnter!
                                  ? theme.colorScheme.primaryContainer
                                  : theme.colorScheme.errorContainer)
                              : theme.colorScheme.tertiaryContainer,
                          foregroundColor: anplrResult != null
                              ? (anplrResult!.allowedToEnter!
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onErrorContainer)
                              : theme.colorScheme.onTertiaryContainer,
                        ),
                      ].addElementBetweenElements(
                        const SizedBox(
                          height: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: ResponsiveWidget.xLargePadding(context),
                  runSpacing: ResponsiveWidget.xLargePadding(context),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Permit Name",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          anplrResult != null ? anplrResult!.permitName! : "-",
                          style: theme.textTheme.headlineLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Days",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        anplrResult != null && anplrResult!.days != null
                            ? DaysIndicator(days: anplrResult!.days!)
                            : Text(
                                "-",
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ].addElementBetweenElements(
                        const SizedBox(
                          height: 12,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Status",
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        anplrResult != null && anplrResult!.status != null
                            ? UserPermitStatusChip(status: anplrResult!.status!)
                            : Text(
                                "-",
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ].addElementBetweenElements(
                        const SizedBox(
                          height: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ].addElementBetweenElements(
                const SizedBox(
                  height: 46,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) => const SearchDialog(),
                    );
                  },
                  icon: const Icon(Icons.search),
                  label: const Text("Manual Search"),
                ),
              ].addElementBetweenElements(
                const SizedBox(
                  width: 24,
                ),
              ),
            ),
          ].addElementBetweenElements(
            SizedBox(
              height: ResponsiveWidget.mediumPadding(context),
            ),
          ),
        ),
      ),
    );
  }
}
