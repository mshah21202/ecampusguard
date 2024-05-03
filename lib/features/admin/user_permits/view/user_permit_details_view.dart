import 'package:ecampusguard/features/admin/user_permits/cubit/user_permits_cubit.dart';
import 'package:ecampusguard/features/admin/user_permits/view/widgets/change_permit_dialog.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/permit_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/personal_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/vehicle_infromation_details.dart';
import 'package:ecampusguard/global/extensions/button_extension.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserPermitDetailsView extends StatefulWidget {
  const UserPermitDetailsView({
    Key? key,
    required this.userPermitId,
  }) : super(key: key);

  final int userPermitId;

  @override
  State<UserPermitDetailsView> createState() => _UserPermitDetailsViewState();
}

class _UserPermitDetailsViewState extends State<UserPermitDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserPermitsCubit>();
    cubit.userPermitId = widget.userPermitId;
    cubit.getUserPermit();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserPermitsCubit>();
    var theme = Theme.of(context);
    return Scaffold(
      appBar: appBar,
      drawer: const AdminAppDrawer(),
      body: BlocBuilder<UserPermitsCubit, UserPermitsState>(
          builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            const BackgroundLogo(),
            if (state is! UserPermitsLoading && cubit.userPermit != null)
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveWidget.mediumPadding(context),
                    horizontal:
                        ResponsiveWidget.xLargeWidthPadding(context) / 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${cubit.userPermit!.user!.name}'s Permit",
                        style: theme.textTheme.headlineLarge
                            ?.copyWith(color: theme.colorScheme.onBackground),
                      ),
                      Wrap(
                        spacing: ResponsiveWidget.smallPadding(context),
                        runSpacing: ResponsiveWidget.smallPadding(context),
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: cubit.userPermit!.status ==
                                    UserPermitStatus.Valid
                                ? () {
                                    showDialog(
                                      useRootNavigator: false,
                                      context: context,
                                      builder: (context) => ChangePermitDialog(
                                        permits: cubit.permits,
                                        initialPermitId:
                                            cubit.userPermit?.permit?.id,
                                        onSave: (permitId) {
                                          cubit.onPermitChanged(permitId);
                                        },
                                      ),
                                    );
                                  }
                                : null,
                            icon: const Icon(Icons.replay),
                            label: const Text("Change Permit"),
                          ),
                          if (cubit.userPermit!.status ==
                              UserPermitStatus.Withdrawn)
                            FilledButton.icon(
                              onPressed: () {
                                showDialog<bool>(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    icon: const Icon(Icons.warning_rounded),
                                    title: const Text("Are you sure?"),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          (ResponsiveWidget.isLargeScreen(
                                                      context) ||
                                                  ResponsiveWidget
                                                      .isMediumScreen(context)
                                              ? 0.2
                                              : 0.8),
                                      child: const Text(
                                          "Reinstating this permit will allow the user to access the parking areas."),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      FilledButton.icon(
                                        onPressed: () {
                                          context.pop(true);
                                        },
                                        icon: const Icon(Icons.warning_rounded),
                                        label: const Text("Reinstate"),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          context.pop(false);
                                        },
                                        icon: const Icon(Icons.close),
                                        label: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ).then((confirm) {
                                  if (confirm ?? false) {
                                    cubit.onWithdraw().then((value) {
                                      context.pop();
                                    });
                                  }
                                });
                              },
                              icon: const Icon(Icons.restart_alt),
                              label: const Text("Reinstate Permit"),
                            ),
                          if (cubit.userPermit!.status ==
                              UserPermitStatus.Valid)
                            ErrorFilledButton.icon(
                              onPressed: () {
                                showDialog<bool>(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    icon: const Icon(Icons.warning_rounded),
                                    title: const Text("Are you sure?"),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          (ResponsiveWidget.isLargeScreen(
                                                      context) ||
                                                  ResponsiveWidget
                                                      .isMediumScreen(context)
                                              ? 0.2
                                              : 0.8),
                                      child: const Text(
                                          "Withdrawing this permit will prevent the user from accessing the parking areas."),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ErrorFilledButton.tonalIcon(
                                        onPressed: () {
                                          context.pop(true);
                                        },
                                        icon: const Icon(Icons.warning_rounded),
                                        label: const Text("Withdraw"),
                                      ),
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          context.pop(false);
                                        },
                                        icon: const Icon(Icons.close),
                                        label: const Text("Cancel"),
                                      ),
                                    ],
                                  ),
                                ).then((confirm) {
                                  if (confirm ?? false) {
                                    cubit.onWithdraw().then((value) {
                                      context.pop();
                                    });
                                  }
                                });
                              },
                              icon: const Icon(Icons.warning_rounded),
                              label: const Text("Withdraw Permit"),
                            ),
                          FilledButton.tonalIcon(
                            onPressed: () {},
                            icon: const Icon(Icons.message),
                            label: const Text("Send Notification"),
                          ),
                        ],
                      ),
                      PermitInformationDetails(
                        userPermit: cubit.userPermit!,
                        permit: cubit.newPermit,
                      ),
                      PersonalInformationDetails(
                        key: cubit.personalInfoKey,
                        userPermit: cubit.userPermit!,
                        countries: cubit.countries,
                      ),
                      VehicleInformationDetails(
                        key: cubit.vehicleInfoKey,
                        userPermit: cubit.userPermit!,
                        countries: cubit.countries,
                      ),
                      Row(
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: cubit.userPermit!.status ==
                                    UserPermitStatus.Valid
                                ? () {
                                    cubit.onSubmit().then((value) {
                                      context.pop();
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.check),
                            label: const Text("Save Changes"),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Cancel & Exit"),
                          ),
                        ].addElementBetweenElements(
                          SizedBox(
                            width: ResponsiveWidget.smallPadding(context),
                          ),
                        ),
                      ),
                    ].addElementBetweenElements(
                      const SizedBox(
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ),
            FullScreenLoadingIndicator(visible: state is UserPermitsLoading),
          ],
        );
      }),
    );
  }
}
