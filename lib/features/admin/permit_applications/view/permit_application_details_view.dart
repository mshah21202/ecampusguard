import 'package:ecampusguard/features/admin/permit_applications/cubit/permit_applications_cubit.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/permit_information.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/personal_information.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/vehicle_information.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class PermitApplicationDetailsView extends StatefulWidget {
  const PermitApplicationDetailsView({
    Key? key,
    required this.applicationId,
  }) : super(key: key);

  final int applicationId;

  @override
  State<PermitApplicationDetailsView> createState() =>
      _PermitApplicationDetailsViewState();
}

class _PermitApplicationDetailsViewState
    extends State<PermitApplicationDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PermitApplicationsCubit>();
    cubit.applicationId = widget.applicationId;
    cubit.populateFields();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitApplicationsCubit>();
    var theme = Theme.of(context);
    return BlocListener<PermitApplicationsCubit, PermitApplicationsState>(
      listener: (context, state) {
        if (state is PermitApplicationsInitial) {
          cubit.populateFields();
        }
      },
      child: Scaffold(
        drawer: const AdminAppDrawer(),
        appBar: appBar,
        body: BlocBuilder<PermitApplicationsCubit, PermitApplicationsState>(
            builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                left: -150,
                bottom: -150,
                child: Opacity(
                  opacity: 0.2,
                  child: AppLogo(
                    darkMode: theme.colorScheme.brightness == Brightness.dark,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.defaultPadding(context),
                    vertical: ResponsiveWidget.defaultPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Review Application",
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(color: theme.colorScheme.onBackground),
                      ),
                      Form(
                        key: cubit.formKey,
                        child: CustomGridView(
                          gap: ResponsiveWidget.smallPadding(context),
                          children: [
                            PersonalDetailsForm(),
                            const VehicleDetailsForm(),
                            const PermitInformationForm()
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              cubit.onSubmit(true);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Save & Accept"),
                          ),
                          SizedBox(
                            width: ResponsiveWidget.smallPadding(context),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              cubit.onSubmit(false);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Deny"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              FullScreenLoadingIndicator(
                visible: state is LoadingPermitApplications,
              )
            ],
          );
        }),
      ),
    );
  }
}
