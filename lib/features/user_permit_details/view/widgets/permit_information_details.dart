import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class PermitInformationDetails extends StatelessWidget {
  const PermitInformationDetails({
    super.key,
    required this.userPermit,
    this.permit,
  });

  final UserPermitDto userPermit;
  final PermitDto? permit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      padding: EdgeInsets.all(
        ResponsiveWidget.smallPadding(context) + 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Permit Information",
            style: theme.textTheme.headlineSmall,
          ),
          Padding(
            padding: EdgeInsets.all(
              ResponsiveWidget.smallPadding(context),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            (permit ?? userPermit.permit)!.name!,
                            style: theme.textTheme.headlineMedium!.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Gate",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            (permit ?? userPermit.permit)!.area!.gate!,
                            style: theme.textTheme.headlineMedium!.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                  ].addElementBetweenElements(
                    const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Status",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          UserPermitStatusChip(
                            status: userPermit.status!,
                          ),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Days",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          DaysIndicator(
                            days: (permit ?? userPermit.permit)!.days!,
                          )
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                  ].addElementBetweenElements(
                    const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
              ].addElementBetweenElements(
                const SizedBox(
                  height: 10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
