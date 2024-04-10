import 'package:ecampusguard/features/home/view/widgets/permit_application_status.dart';
import 'package:ecampusguard/features/home/view/widgets/permit_status.dart';
import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
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
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (state.applicationStatus != null)
                    PermitApplicationStatusWidget(
                      status: state.applicationStatus!,
                    ),
                  if (state.applicationStatus == null &&
                      state.permitStatus != null)
                    PermitStatusWidget(status: state.permitStatus!),
                  const PreviousPermits(permits: [])
                ],
              );
            },
          ),
          const BackgroundLogo()
        ],
      ),
    );
  }
}


















  // //icon functions
  // IconData? _getIconData(PermitApplicationStatus status) {
  //   switch (status) {
  //     case PermitApplicationStatus.Valid:
  //       return Icons.check_circle_outline;
  //     case PermitApplicationStatus.Pending:
  //       return Icons.hourglass_empty;
  //     case PermitApplicationStatus.AwaitingPayment:
  //       return Icons.payment;
  //     case PermitApplicationStatus.Expired:
  //       return Icons.alarm;
  //     default:
  //       return Icons.help_outline;
  //   }
  // }

  // String _getTextBasedOnStatus(PermitApplicationStatus status) {
  //   switch (status) {
  //     case PermitApplicationStatus.Valid:
  //       return 'Application is Valid';
  //     case PermitApplicationStatus.Pending:
  //       return 'Application Pending';
  //     case PermitApplicationStatus.AwaitingPayment:
  //       return 'Awaiting Payment';
  //     case PermitApplicationStatus.Expired:
  //       return 'Permit Expired';
  //     default:
  //       return '';
  //   }
  // }
