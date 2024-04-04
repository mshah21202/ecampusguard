import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/permit_information.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/personal_information.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/vehicle_information.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../apply_for_permit.dart';

class ApplyForPermitView extends StatefulWidget {
  const ApplyForPermitView({
    Key? key,
  }) : super(key: key);

  @override
  State<ApplyForPermitView> createState() => _ApplyForPermitViewState();
}

class _ApplyForPermitViewState extends State<ApplyForPermitView> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<ApplyForPermitCubit>();

    cubit.attendingDaysController.addListener(cubit.handleAttendingDays);
    cubit.academicYearController.addListener(() {
      cubit.academicYearController.text = cubit.academicYear != null
          ? cubit.academicYears[cubit.academicYear!]
          : "";
    });

    cubit.loadCountries();
    cubit.loadPermits();
  }

  @override
  void dispose() {
    var cubit = context.read<ApplyForPermitCubit>();

    cubit.attendingDaysController.dispose();
    cubit.academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplyForPermitCubit>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          child: Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Apply for a permit",
                  style: theme.textTheme.headlineLarge
                      ?.copyWith(color: theme.colorScheme.onBackground),
                ),
                const PersonalDetailsForm(),
                const VehicleDetailsForm(),
                const PermitInformationForm(),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      label: const Text("Send Application"),
                      icon: const Icon(Icons.check),
                    ),
                    const SizedBox(width: 25),
                    OutlinedButton.icon(
                      onPressed: () {},
                      label: const Text("Cancel & Exit"),
                      icon: const Icon(Icons.close),
                    )
                  ],
                )
              ].addElementBetweenElements(const SizedBox(
                height: 25,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
