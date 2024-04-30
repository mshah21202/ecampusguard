import 'package:ecampusguard/features/user_permit_details/view/widgets/permit_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/personal_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/vehicle_infromation_details.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
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
      appBar: appBar,
      drawer: const AppDrawer(),
      body: BlocBuilder<UserPermitDetailsCubit, UserPermitDetailsState>(
        builder: (context, state) {
          final cubit = context.read<UserPermitDetailsCubit>();
          var theme = Theme.of(context);
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveWidget.mediumPadding(context),
                    horizontal:
                        ResponsiveWidget.xLargeWidthPadding(context) / 2,
                  ),
                  child: (cubit.userPermit != null)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "My Permit Information",
                              style: theme.textTheme.headlineLarge?.copyWith(
                                  color: theme.colorScheme.onBackground),
                            ),
                            const PermitInformationDetails(),
                            const PersonalInformationDetails(),
                            const VehicleInformationDetails(),
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
                        )
                      : null,
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
