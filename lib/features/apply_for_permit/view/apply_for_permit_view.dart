import 'dart:ui';

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

    cubit.drivingLicenseController.addListener(() {
      cubit.disableEditingHandler(
          cubit.drivingLicenseImgFile!.name, cubit.drivingLicenseController);
    });

    cubit.carRegistrationController.addListener(() {
      cubit.disableEditingHandler(
          cubit.carRegistrationImgFile!.name, cubit.carRegistrationController);
    });

    cubit.loadCountries();
    cubit.loadPermits();
  }

  @override
  void dispose() {
    var cubit = context.read<ApplyForPermitCubit>();

    cubit.drivingLicenseController.dispose();
    cubit.carRegistrationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplyForPermitCubit>();
    final theme = Theme.of(context);
    return BlocListener<ApplyForPermitCubit, ApplyForPermitState>(
      listener: (BuildContext context, ApplyForPermitState state) {
        if ((state is LoadedApplyForPermitState ||
                state is FailedApplyForPermitState) &&
            state.snackBarMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.snackBarMessage!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              elevation: 12,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 25),
              showCloseIcon: true,
              closeIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: appBar,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
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
                            onPressed: () {
                              cubit.onSubmit();
                            },
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
            BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                builder: (context, state) {
              return Visibility(
                visible: state is LoadingApplyForPermitState,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 1.2,
                    sigmaY: 1.2,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Color.fromARGB((255 * 0.50).toInt(), 0, 0, 0),
                    ),
                    child: LinearProgressIndicator(
                      minHeight: 3,
                      color: Theme.of(context).colorScheme.secondary,
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
