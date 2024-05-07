import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/features/home/home.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// This widget displays the permit's status information. It has 3 states, [ValidPermit], [WithdrawnPermit], & [ExpiredPermit].
///
/// Use this if [HomeState]'s [userPermit] is not [null].
class PermitStatusWidget extends StatefulWidget {
  const PermitStatusWidget({
    super.key,
  });

  @override
  State<PermitStatusWidget> createState() => _PermitStatusWidgetState();
}

class _PermitStatusWidgetState extends State<PermitStatusWidget> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<HomeCubit>();
    cubit.fetchUserPermitDto();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocBuilder<HomeCubit, HomeState>(
      // buildWhen: (previous, current) {
      //   return current is LoadedHomeState;
      // },
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
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _permitInformationWidget(cubit, theme),
                      _permitActions(cubit, theme),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _permitInformationWidget(cubit, theme),
                      _permitActions(cubit, theme),
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.defaultPadding(context),
                      ),
                    ),
                  ),
          );
        } else {
          return const Center();
        }
      },
    );
  }

  Widget _permitActions(HomeCubit cubit, ThemeData theme) => Flexible(
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
                      width: 2,
                    )
                  : BorderSide.none,
              top: ResponsiveWidget.isLargeScreen(context) ||
                      ResponsiveWidget.isMediumScreen(context)
                  ? BorderSide.none
                  : BorderSide(
                      color: theme.colorScheme.outline.withOpacity(0.16),
                      width: 2,
                    ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (cubit.userPermit!.status == UserPermitStatus.Valid)
                  FilledButton(
                    onPressed: () {
                      context.go("$homeRoute$userPermitDetailsRoute");
                    },
                    child: const Text(
                      "Update Details",
                    ),
                  ),
                if (cubit.userPermit!.status == UserPermitStatus.Expired)
                  FilledButton(
                    onPressed: () {
                      context.go("$homeRoute$applyForPermitRoute");
                    },
                    child: const Text(
                      "Apply now",
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget _permitInformationWidget(HomeCubit cubit, ThemeData theme) => Flexible(
        flex: ResponsiveWidget.isLargeScreen(context) ||
                ResponsiveWidget.isMediumScreen(context)
            ? 3
            : 12,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                cubit.userPermit!.permit!.name!,
                style: theme.textTheme.headlineLarge!.copyWith(
                  color: theme.colorScheme.onBackground,
                ),
              ),
              Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 44,
                        child: Text('Status: ',
                            style: theme.textTheme.headlineSmall),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 44,
                        child: Text('Days: ',
                            style: theme.textTheme.headlineSmall),
                      ),
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 44,
                        child: UserPermitStatusChip(
                          status: cubit.userPermit!.status!,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 44,
                        child: DaysIndicator(
                            days: cubit.userPermit!.permit!.days!),
                      ),
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
                  ),
                ].addElementBetweenElements(
                  SizedBox(
                    width: ResponsiveWidget.smallPadding(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
