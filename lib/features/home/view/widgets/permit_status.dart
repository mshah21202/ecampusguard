import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

/// This widget displays the permit's status information. It has 3 states, [ValidPermit], [WithdrawnPermit], & [ExpiredPermit].
///
/// Use this if [HomeState]'s [userPermit] is not [null].
class PermitStatusWidget extends StatelessWidget {
  const PermitStatusWidget({super.key, required this.status});

  final UserPermitStatus status;

//Valid
  Widget _buildAppliedWidget(ThemeData theme) {
    return Column(
      children: [
        Row(
          children:<Widget> [
            const Column(
              children: [
                    Text('Engineering Parking Permit',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],

            ),
            const Row(
              children: [
                Icon(Icons.check,),
                SizedBox(width: 8.0),
                Text('Status: Valid', style: TextStyle(fontSize: 18)),
                Text('Days:', style: TextStyle(fontSize: 18)),

              ],
            ),

            const SizedBox(width: 300),
            Column(
              children: [
                FilledButton(
                  onPressed: () {
                    //navigate to the application form
                  },
                  child: const Text('Update Details'),
                ),

              ],
            ),
          ].addElementBetweenElements(
              const SizedBox(height: 10,)),
        ),
      ],
    );
  }






  //withdrawn
  Widget _buildWithdrawnWidget(ThemeData theme) {


    return Container();



  }

  //expired
  Widget _buildExpiredStatus(ThemeData theme) {
    return Container();



  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget statusWidget;
    switch (status) {
      case UserPermitStatus.Valid:
        statusWidget = _buildAppliedWidget(theme);
      case UserPermitStatus.Withdrawn:
        statusWidget = _buildWithdrawnWidget(theme);
      case UserPermitStatus.Expired:
        statusWidget = _buildExpiredStatus(theme);
      default:
        return Container();
    }

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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          statusWidget,

        ],
      ),
    );
  }
}



