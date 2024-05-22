import 'package:ecampusguard/features/user_permit_applications/cubit/user_permit_applications_cubit.dart';
import 'package:ecampusguard/features/user_permit_applications/view/widgets/application_details.dart';
import 'package:ecampusguard/features/user_permit_applications/view/widgets/permit_information_details.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserPermitApplicationDetails extends StatefulWidget {
  const UserPermitApplicationDetails({
    super.key,
    required this.applicationId,
  });

  final int applicationId;

  @override
  State<UserPermitApplicationDetails> createState() =>
      _UserPermitApplicationDetailsState();
}

class _UserPermitApplicationDetailsState
    extends State<UserPermitApplicationDetails> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UserPermitApplicationsCubit>();
    cubit.applicationId = widget.applicationId;
    cubit.getApplicationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserPermitApplicationsCubit,
        UserPermitApplicationsState>(
      builder: (context, state) {
        var cubit = context.read<UserPermitApplicationsCubit>();
        var theme = Theme.of(context);
        return Scaffold(
          appBar: appBar(),
          drawer: const AppDrawer(),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              if (state is! UserPermitApplicationsLoading &&
                  cubit.permitApplication != null)
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
                          "Application Information",
                          style: theme.textTheme.headlineLarge
                              ?.copyWith(color: theme.colorScheme.onBackground),
                        ),
                        const ApplicationDetails(),
                        const PermitInformationDetails(),
                        Row(
                          children: <Widget>[
                            FilledButton.icon(
                              onPressed: () {
                                cubit.getApplicationDetails();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text("Check for updates"),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {
                                context.pop();
                              },
                              icon: const Icon(Icons.arrow_back_ios_new),
                              label: const Text("Back"),
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
                  ),
                ),
              FullScreenLoadingIndicator(
                  visible: state is UserPermitApplicationsLoading)
            ],
          ),
        );
      },
    );
  }
}
