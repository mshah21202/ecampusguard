// import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:bloc/bloc.dart';
import 'package:ecampusguard/features/home/cubit/home_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              height: MediaQuery.of(context).size.height *
                  (ResponsiveWidget.isLargeScreen(context) ||
                          ResponsiveWidget.isMediumScreen(context)
                      ? 0.27
                      : 0.45),
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
                    ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // _PermitType(cubit, theme),
                  _applicationDetails(cubit, theme),
                  _applicationActions(cubit, theme),
                  // _applicationInfo(cubit, theme),
                ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.defaultPadding(context),
                      ),
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
                        height: ResponsiveWidget.defaultPadding(context),
                      ),
                    ),
              )
              );
        } else {
          return const Center();
        }
      },
    );
  }

Widget _applicationDetails(HomeCubit cubit, ThemeData theme) {
  return Flexible(
    flex: ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context) ? 3 : 12,
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            cubit.permitApplication != null ? cubit.permitApplication!.permitName! : "Apply for permit",
            style: TextStyle(fontSize: 35),
          ),
          // SizedBox(height: 20),



          if (cubit.permitApplication != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Application Sent', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Status: ', style: TextStyle(fontSize: 20)),
                PermitApplicationStatusChip(
                  status: cubit.permitApplication!.status!,
                ),
              ]
            ),



          if (cubit.permitApplication == null)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary, 
                foregroundColor: theme.colorScheme.onPrimary, 
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // do amth 
              },
              child: Text('Apply Now'),
            ),

        ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.defaultPadding(context),
                      ),
                    ),
      ),
    ),
  );
}

Widget _applicationActions(HomeCubit cubit, ThemeData theme) {
  return Flexible(
    flex: ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context) ? 1 : 6,
    child: Container(
      decoration: BoxDecoration(
        border: Border(
          left: ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context) ? BorderSide(color: theme.colorScheme.outline.withOpacity(0.16), width: 2) : BorderSide.none,
          top: ResponsiveWidget.isLargeScreen(context) || ResponsiveWidget.isMediumScreen(context) ? BorderSide.none : BorderSide(color: theme.colorScheme.outline.withOpacity(0.16), width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cubit.permitApplication != null && cubit.permitApplication!.status == PermitApplicationStatus.Pending)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, 
                  foregroundColor: theme.colorScheme.onPrimary, 
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                 //do smth
                },
                child: Text('Check Application'),
              ),
            if (cubit.permitApplication != null && cubit.permitApplication!.status == PermitApplicationStatus.AwaitingPayment)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                onPressed: () {
                  // do smth
                },
                child: Text('Pay Now'),
              ),
          ],
        ),
      ),
    ),
  );
}
}
