import 'package:ecampusguard/features/home/view/widgets/enterexit_logs.dart';
import 'package:ecampusguard/features/home/view/widgets/permit_status.dart';
import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
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
      appBar: appBar,
      drawer: const AppDrawer(),
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          return current.homeScreenDto != null;
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              if (state is! LoadingHomeState && state.homeScreenDto != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.largePadding(context),
                      vertical: ResponsiveWidget.mediumPadding(context),
                    ),
                    child: Column(
                      children: [
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.PermitStatus))
                          const PermitStatusWidget(),
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.PreviousPermits))
                          const PreviousPermits(permits: []),
                        if (state.homeScreenDto!.homeScreenWidgets!
                            .contains(HomeScreenWidget.AccessLogs))
                          const AccessLogsList(),
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
