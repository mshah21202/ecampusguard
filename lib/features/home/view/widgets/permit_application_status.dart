import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

/// This widget displays the permit application's status.
///
/// It has 3 states: [Pending, AwaitingPayment, Paid, Denied]
///
/// Use this when [HomeState]'s [permitStatus] is [null].
class PermitApplicationStatusWidget extends StatelessWidget {
  const PermitApplicationStatusWidget({super.key, required this.status});

  final PermitApplicationStatus status;
  @override
  Widget build(BuildContext context) {
    return _buildApplyNow(context);
  }

  Widget _buildApplyNow(BuildContext context) {
    var theme = Theme.of(context);

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
          SizedBox(
            height: 100,
            child: Text(
              'Apply for a permit',
              style: TextStyle(
                fontSize: 24,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // do smth
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
              elevation: 0,
            ),
            child: const Text(
              'Apply now',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
