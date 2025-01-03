import 'package:ecampusguard/features/user_permit_details/view/widgets/permit_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/personal_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/vehicle_infromation_details.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../user_permit_details.dart';

class UserPermitDetailsView extends StatefulWidget {
  const UserPermitDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPermitDetailsView> createState() => _UserPermitDetailsViewState();
}

class _UserPermitDetailsViewState extends State<UserPermitDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserPermitDetailsCubit>();
    cubit.getUserPermit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const AppDrawer(),
      body: BlocConsumer<UserPermitDetailsCubit, UserPermitDetailsState>(
        listener: (context, state) {
          if (state.snackbarMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              appSnackBar(state.snackbarMessage!, context),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<UserPermitDetailsCubit>();
          var theme = Theme.of(context);
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              SingleChildScrollView(
                child: (cubit.userPermit != null)
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ResponsiveWidget.mediumPadding(context),
                          horizontal:
                              ResponsiveWidget.xLargeWidthPadding(context) / 2,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "My Permit Information",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.onBackground),
                            ),
                            PermitInformationDetails(
                              userPermit: cubit.userPermit!,
                            ),
                            PersonalInformationDetails(
                              key: cubit.personalInfoKey,
                              userPermit: cubit.userPermit!,
                              countries: cubit.countries,
                            ),
                            VehicleInformationDetails(
                              key: cubit.carInfoKey,
                              userPermit: cubit.userPermit!,
                              countries: cubit.countries,
                            ),
                            Row(
                              children: <Widget>[
                                FilledButton.icon(
                                  onPressed: () async {
                                    await cubit.onSubmit();
                                    if (context.mounted) {
                                      context.pop();
                                    }
                                  },
                                  icon: const Icon(Icons.check_rounded),
                                  label: const Text("Request Details Update"),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Cancel"),
                                ),
                              ].addElementBetweenElements(
                                SizedBox(
                                  width: ResponsiveWidget.smallPadding(context),
                                ),
                              ),
                            ),
                          ].addElementBetweenElements(
                            SizedBox(
                              height: ResponsiveWidget.smallPadding(context),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height -
                            (Scaffold.of(context).appBarMaxHeight ?? 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "You don't have a permit yet",
                              style: theme.textTheme.headlineLarge!.copyWith(
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                            FilledButton(
                                onPressed: () {
                                  context.go("$homeRoute$applyForPermitRoute");
                                },
                                child: const Text("Apply Now"))
                          ].addElementBetweenElements(
                            SizedBox(
                              height: ResponsiveWidget.mediumPadding(context),
                            ),
                          ),
                        ),
                      ),
              ),
              FullScreenLoadingIndicator(
                  visible: state is UserPermitDetailsLoading),
            ],
          );
        },
      ),
    );
  }
}
