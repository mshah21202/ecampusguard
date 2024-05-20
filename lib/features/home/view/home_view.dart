import 'package:ecampusguard/features/home/view/widgets/enterexit_logs.dart';
import 'package:ecampusguard/features/home/view/widgets/permit_application_status.dart';
import 'package:ecampusguard/features/home/view/widgets/permit_status.dart';
import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../home.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(),
      drawer: const AppDrawer(),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.snackbarMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              appSnackBar(state.snackbarMessage!, context),
            );
          }
        },
        buildWhen: (previous, current) {
          return current.homeScreenDto != null;
        },
        builder: (context, state) {
          var cubit = context.read<HomeCubit>();
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              if (state is! LoadingHomeState && state.homeScreenDto != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.xLargePadding(context),
                      vertical: ResponsiveWidget.mediumPadding(context),
                    ),
                    child: Column(
                      children: [
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.ApplicationStatus))
                          const PermitApplicationStatusWidget(),
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.PermitStatus))
                          const PermitStatusWidget(),
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.PreviousPermits))
                          const PreviousPermits(permits: []),
                        if (state.homeScreenDto!.homeScreenWidgets!
                                .contains(HomeScreenWidget.AccessLogs) &&
                            cubit.userPermit != null)
                          AccessLogsList(
                            accessLogs: cubit.userPermit!.accessLogs!,
                          ),
                      ].addElementBetweenElements(
                        SizedBox(
                          height: ResponsiveWidget.mediumPadding(context),
                        ),
                      ),
                    ),
                  ),
                ),
              FullScreenLoadingIndicator(visible: state is LoadingHomeState),
            ],
          );
        },
      ),
    );
  }
}
