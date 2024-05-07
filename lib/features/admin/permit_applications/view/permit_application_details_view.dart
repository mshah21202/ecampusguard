import 'package:ecampusguard/features/admin/permit_applications/cubit/permit_applications_cubit.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/permit_information.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/personal_information.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/form_widgets/vehicle_information.dart';
import 'package:ecampusguard/global/extensions/button_extension.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      drawer: const AdminAppDrawer(),
      appBar: appBar,
      body: BlocBuilder<PermitApplicationsCubit, PermitApplicationsState>(
        builder: (context, state) {
          return Stack(
            children: [
              const BackgroundLogo(),
              if (cubit.permitApplication != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveWidget.mediumPadding(context),
                      horizontal:
                          ResponsiveWidget.xLargeWidthPadding(context) / 2,
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${cubit.permitApplication!.studentName}'s Application",
                                style: theme.textTheme.headlineLarge?.copyWith(
                                    color: theme.colorScheme.onBackground),
                              ),
                              if (cubit.permitApplication != null)
                                PermitApplicationStatusChip(
                                    status: cubit.permitApplication!.status!),
                            ].addElementBetweenElements(
                              const SizedBox(
                                height: 12,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              if (cubit.permitApplication!.status ==
                                      PermitApplicationStatus.Pending ||
                                  cubit.permitApplication!.status ==
                                      PermitApplicationStatus.Denied)
                                FilledButton.icon(
                                  onPressed: () {
                                    cubit.onSubmit(true).then((value) {
                                      context.pop();
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Save & Accept"),
                                ),
                              if (cubit.permitApplication!.status ==
                                  PermitApplicationStatus.Paid)
                                FilledButton(
                                  onPressed: () {
                                    context.go(
                                        "$adminHomeRoute/$adminUserPermitsRoute/${cubit.permitApplication!.userPermitId}");
                                  },
                                  child: const Text("View User Permit"),
                                ),
                              if (cubit.permitApplication!.status ==
                                  PermitApplicationStatus.AwaitingPayment)
                                FilledButton.icon(
                                  onPressed: () {
                                    cubit.onPayment().then((value) {
                                      context.pop();
                                    });
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Mark as Paid"),
                                ),
                              if (cubit.permitApplication!.status ==
                                      PermitApplicationStatus.Pending ||
                                  cubit.permitApplication!.status ==
                                      PermitApplicationStatus.AwaitingPayment)
                                ErrorFilledButton.tonalIcon(
                                  onPressed: () {
                                    cubit.onSubmit(false).then((value) {
                                      context.pop();
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Deny"),
                                ),
                            ],
                          ),
                          PersonalDetailsForm(),
                          const VehicleDetailsForm(),
                          const PermitInformationForm(),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              FullScreenLoadingIndicator(
                visible: state is LoadingPermitApplications ||
                    cubit.permitApplication == null,
              )
            ],
          );
        },
      ),
    );
  }
}
