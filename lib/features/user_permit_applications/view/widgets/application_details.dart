import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguard/features/user_permit_applications/cubit/user_permit_applications_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicationDetails extends StatelessWidget {
  const ApplicationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cubit = context.read<UserPermitApplicationsCubit>();
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
        children: <Widget>[
          Text(
            "Application Details",
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
                            "Plate Number",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            cubit.permitApplication!.vehicle!.plateNumber,
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
                            "Status",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          PermitApplicationStatusChip(
                            status: cubit.permitApplication!.status!,
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
                            "Phone Number",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            "${cubit.selectedPhoneCountry!.phoneCode[0] != '+' ? '+' : ""}${cubit.selectedPhoneCountry!.phoneCode}${cubit.permitApplication!.phoneNumber!}",
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
                            "Academic Year",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: theme.colorScheme.onBackground
                                  .withOpacity(0.5),
                            ),
                          ),
                          Text(
                            cubit.permitApplication!.academicYear!.name,
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
              ].addElementBetweenElements(
                const SizedBox(
                  height: 10,
                ),
              ),
            ),
          ),
        ].addElementBetweenElements(
          const SizedBox(
            height: 10,
          ),
        ),
      ),
    );
  }
}
