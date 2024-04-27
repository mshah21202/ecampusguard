import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/features/home/home.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    cubit.fetchPermitStatus();
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        cubit.userPermit!.permit!.name!,
                        style: theme.textTheme.headlineLarge!.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text('Status: ',
                                    style: theme.textTheme.headlineSmall),
                              ),
                              UserPermitStatusChip(
                                status: cubit.userPermit!.status!,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text('Days: ',
                                    style: theme.textTheme.headlineSmall),
                              ),
                              DaysIndicator(
                                  days: cubit.userPermit!.permit!.days!),
                            ],
                          ),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 14,
                          ),
                        ),
                      ),
                    ].addElementBetweenElements(
                      const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () {
                          //do smth
                        },
                        child: const Text(
                          "Update Details",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}
