// import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This widget displays the permit application's status.
///
/// It has 3 states: [Pending, AwaitingPayment, Paid, Denied]
///
/// Use this when [HomeState]'s [permitStatus] is [null].
class PermitApplicationStatusWidget extends StatelessWidget {
  const PermitApplicationStatusWidget({super.key, required this.status});

  final PermitApplicationStatus status;

  //pending stat
  Widget _buildPendingStatus(ThemeData theme) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Application Sent',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),


                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Status: ', style: TextStyle(fontSize: 20)),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),

                      child:const Row(
                        children: [
                          Icon(Icons.pending_outlined, ),
                          const SizedBox(width: 10),
                          Text('Pending', style: TextStyle(fontSize: 16,)),
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
                    // Student check his application
                  },
                        child: const Text(
                        'Check Application',
                        style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ].addElementBetweenElements(const SizedBox(width: 30),),
        ),
      );
  }

//Awaiting stat
  Widget _buildAwaitingPaymentStatus(ThemeData theme) {

    return Padding(

      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Application Sent',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Status: ', style: TextStyle(fontSize: 20)),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),

                    child: Row(
                      children: [
                        Icon(Icons.payment_outlined, color: theme.colorScheme.onSecondary),
                        const SizedBox(width: 10),
                        Text('Awaiting Payment', style: TextStyle(fontSize: 16,  color: theme.colorScheme.onSecondary)),
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
                  // Student check his application
                },
                child: const Text(
                  'Pay Now',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ].addElementBetweenElements(const SizedBox(width: 30),),
      ),
    );
  }

  //Denied
  Widget _buildDeniedStatus(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Application Denied',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Status: ', style: TextStyle(fontSize: 20)),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),

                    child:const Row(
                      children: [
                        Icon(Icons.error_outline, ),
                        const SizedBox(width: 10),
                        Text('Denied', style: TextStyle(fontSize: 16,)),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ].addElementBetweenElements(const SizedBox(width: 30),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget statusWidget;
    switch (status) {

      case PermitApplicationStatus.Pending:
         statusWidget = _buildPendingStatus(theme);
      case PermitApplicationStatus.AwaitingPayment:
         statusWidget = _buildAwaitingPaymentStatus(theme);
      case PermitApplicationStatus.Denied:
         statusWidget = _buildDeniedStatus(theme);
      default:
        return Container();
    }
    return Container(
      margin: const EdgeInsets.all(20),
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
