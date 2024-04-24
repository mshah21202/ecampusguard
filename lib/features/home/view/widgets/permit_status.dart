import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import '../../../apply_for_permit/view/form_widgets/days_indicator.dart';

/// This widget displays the permit's status information. It has 3 states, [ValidPermit], [WithdrawnPermit], & [ExpiredPermit].
///
/// Use this if [HomeState]'s [userPermit] is not [null].
class PermitStatusWidget extends StatelessWidget {
  const PermitStatusWidget({super.key, required this.status});

  final UserPermitStatus status;


/*//Valid
  Widget _buildAppliedWidget(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Engineering Parking Permit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Status: ', style: TextStyle(fontSize: 20)),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),

                    child:const Row(
                      children: [
                        Icon(Icons.check, ),
                        const SizedBox(width: 10),
                        Text('Valid', style: TextStyle(fontSize: 16,)),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
          const SizedBox(width: 500),
          Column(
            children: [
              FilledButton(
                onPressed: () {
                  // Update details
                },
                child: const Text(
                  'Update Details',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ].addElementBetweenElements(const SizedBox(width: 30),),
      ),
    );
  }






  //withdrawn
  Widget _buildWithdrawnWidget(ThemeData theme) {


    return Container();



  }

  //expired
  Widget _buildExpiredStatus(ThemeData theme) {
    return Container();



  }*/

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<bool> daysActive = [false, true, true, false, true];

    Widget statusWidget;

    switch (status) {
      case UserPermitStatus.Valid:
        statusWidget = _buildStatusWidget(
          theme,
          'Valid',
          Icons.check,
          theme.colorScheme.secondaryContainer,
          'Update Details',
        );
        break;
      case UserPermitStatus.Withdrawn:
        statusWidget = _buildStatusWidget(
          theme,
          'Withdrawn',
          Icons.error_outline,
          theme.colorScheme.errorContainer,
          'Apply Now',
        );
        break;
      case UserPermitStatus.Expired:
        statusWidget = _buildStatusWidget(
          theme,
          'Expired',
          Icons.alarm,
          theme.colorScheme.error,
          'Apply Now',
        );
        break;


      default:
        return const SizedBox.shrink();
    }




    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow:  [
          BoxShadow(
            color: Colors.black.withOpacity(0.19),
            blurRadius: 25.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statusWidget,
            const SizedBox(height: 16),
            DaysIndicator(days: daysActive), // Here we use the DaysIndicator
          ],
        ),
      ),
    );
  }

}
Widget _buildStatusWidget(ThemeData theme, String statusText, IconData statusIcon, Color bgColor, String buttonText) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Engineering Parking Permit',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('Status: ', style: TextStyle(fontSize: 20)),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon),
                    const SizedBox(width: 10),
                    Text(statusText, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(width: 100),
      Column(
        children: [
          FilledButton(
            onPressed: () {
              //do smth
            },
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    ].addElementBetweenElements(const SizedBox(width: 30)),
  );
}



