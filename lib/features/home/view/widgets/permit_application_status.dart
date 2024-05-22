import 'package:ecampusguard/features/home/cubit/home_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../global/widgets/responsive.dart';
import '../../../admin/permit_applications/view/widgets/application_status_chip.dart';

/// This widget displays the permit application's status.
///
/// It has 3 states: [Pending, AwaitingPayment, Paid, Denied]
///
/// Use this when [HomeState]'s [permitStatus] is [null].
class PermitApplicationStatusWidget extends StatefulWidget {
  const PermitApplicationStatusWidget({
    super.key,
  });

  @override
  State<PermitApplicationStatusWidget> createState() =>
      _PermitApplicationStatusWidgetState();
}

class _PermitApplicationStatusWidgetState
    extends State<PermitApplicationStatusWidget> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<HomeCubit>();
    cubit.fetchApplicationStatus();
  }

  // final PermitApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        if (state is! LoadingHomeState) {
          return Container(
              // FIXME: We want the height of container to be as small as possible
              // height: MediaQuery.of(context).size.height *
              //     (ResponsiveWidget.isLargeScreen(context) ||
              //             ResponsiveWidget.isMediumScreen(context)
              //         ? 0.27
              //         : 0.45),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.19),
                    blurRadius: 25.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? IntrinsicHeight(
                      // FIXME: We want the height of container to be as small as possible
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween, FIXME: This was causing issues with sizes
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // _PermitType(cubit, theme),
                          _applicationDetails(cubit, theme),
                          _applicationActions(cubit, theme),
                          // _applicationInfo(cubit, theme),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // _PermitType(cubit, theme),
                        _applicationDetails(cubit, theme),
                        _applicationActions(cubit, theme),
                        // _applicationInfo(cubit, theme),
                      ].addElementBetweenElements(
                        SizedBox(
                          height: ResponsiveWidget.xLargePadding(context),
                        ),
                      ),
                    ));
        } else {
          return const Center();
        }
      },
    );
  }

  Widget _applicationDetails(HomeCubit cubit, ThemeData theme) {
    return Flexible(
      flex: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 4
          : 12,
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              cubit.permitApplication != null
                  ? "Application Sent"
                  : "Apply for permit",
              style: theme.textTheme.headlineLarge!.copyWith(
                color: theme.colorScheme.onBackground,
              ),
            ),
            if (cubit.permitApplication != null)
              // FIXME: Row was missing here.
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: theme
                        .textTheme.titleLarge, // FIXME: Used predefined theme.
                  ),
                  PermitApplicationStatusChip(
                    status: cubit.permitApplication!.status!,
                  ),
                ],
              ),
            //
            // FIXME: This belongs in the _applicationActions, it is a button.
            // if (cubit.permitApplication ==
            //     null)
            //   FilledButton(
            //     style: FilledButton.styleFrom(
            //       backgroundColor: theme.colorScheme.primary,
            //       foregroundColor: theme.colorScheme.onPrimary,
            //       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30),
            //       ),
            //     ),
            //     onPressed: () {
            //       // do amth
            //     },
            //     child: Text('Apply Now'),
            //   ),
          ].addElementBetweenElements(
            const SizedBox(
              height: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget _applicationActions(HomeCubit cubit, ThemeData theme) {
    return Flexible(
      flex: ResponsiveWidget.isLargeScreen(context) ||
              ResponsiveWidget.isMediumScreen(context)
          ? 1
          : 6,
      fit: FlexFit.tight,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: ResponsiveWidget.isLargeScreen(context) ||
                    ResponsiveWidget.isMediumScreen(context)
                ? BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.16),
                    width: 2)
                : BorderSide.none,
            top: ResponsiveWidget.isLargeScreen(context) ||
                    ResponsiveWidget.isMediumScreen(context)
                ? BorderSide.none
                : BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.16),
                    width: 2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            24.0, // FIXME: This needs to be the same amount of the _applicationDetails.
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // FIXME: This was placed in the permitDetails.
              if (cubit.permitApplication == null)
                FilledButton(
                  // FIXME: No need to style.
                  // style: FilledButton.styleFrom(
                  //   backgroundColor: theme.colorScheme.primary,
                  //   foregroundColor: theme.colorScheme.onPrimary,
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 32, vertical: 16),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30),
                  //   ),
                  // ),
                  onPressed: () {
                    context.go("$homeRoute$applyForPermitRoute");
                  },
                  child: const Text('Apply Now'),
                ),
              if (cubit.permitApplication != null &&
                  cubit.permitApplication!.status ==
                      PermitApplicationStatus.Pending)
                FilledButton(
                  onPressed: () {
                    context.go(
                        "$homeRoute$userApplicationsRoute/${cubit.permitApplication!.id!}");
                  },
                  child: const Text('Check Application'),
                ),
              if (cubit.permitApplication != null &&
                  cubit.permitApplication!.status ==
                      PermitApplicationStatus.AwaitingPayment)
                FilledButton(
                  onPressed: () {
                    cubit.onPay();
                  },
                  child: const Text('Pay Now'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
