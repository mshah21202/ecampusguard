import 'package:ecampusguard/features/gatestaff/area_screen/view/widgets/anplr_widget.dart';
import 'package:ecampusguard/features/home/view/widgets/enterexit_logs.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../area_screen.dart';

class AreaScreenView extends StatefulWidget {
  const AreaScreenView({
    Key? key,
  }) : super(key: key);

  @override
  State<AreaScreenView> createState() => _AreaScreenViewState();
}

class _AreaScreenViewState extends State<AreaScreenView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AreaScreenCubit>();
    cubit.getAreaScreen().then((value) {
      cubit.connectToHub();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AreaScreenCubit>();
    var theme = Theme.of(context);
    return BlocConsumer<AreaScreenCubit, AreaScreenState>(
      listener: (context, state) {
        if (state.snackbarMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar(state.snackbarMessage!, context),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: appBar(
            automaticallyImplyLeading: true,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              if (cubit.areaScreen != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ResponsiveWidget.largePadding(context),
                      right: ResponsiveWidget.largePadding(context),
                      bottom: ResponsiveWidget.mediumPadding(context),
                      top: ResponsiveWidget.smallPadding(context),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${cubit.areaScreen!.name} Area",
                          style: theme.textTheme.headlineMedium!.copyWith(
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                        AnplrWidget(
                          anplrResult: cubit.anplrResult,
                          connected: cubit.connected,
                          connecting: state is HubConnectionLoading,
                          onRefresh: () {
                            cubit.connectToHub();
                          },
                        ),
                        AccessLogsList(
                          accessLogs:
                              cubit.areaScreen!.accessLogs!.reversed.toList(),
                          showPlateNumber: true,
                          showEmpty: true,
                        )
                      ].addElementBetweenElements(
                        const SizedBox(
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              FullScreenLoadingIndicator(
                visible: state is AreaScreenLoading ||
                    cubit.areaScreen == null && state is! AreaScreenError,
              ),
            ],
          ),
        );
      },
    );
  }
}
