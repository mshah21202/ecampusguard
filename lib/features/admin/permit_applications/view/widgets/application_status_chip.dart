import 'package:ecampusguard/global/widgets/raw_status_chip.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class PermitApplicationStatusChip extends StatelessWidget {
  const PermitApplicationStatusChip({super.key, required this.status});

  final PermitApplicationStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case PermitApplicationStatus.AwaitingPayment:
        return _buildAwaitingPaymentChip(context);
      case PermitApplicationStatus.Pending:
        return _buildPendingChip(context);
      case PermitApplicationStatus.Paid:
        return _buildPaidChip(context);
      case PermitApplicationStatus.Denied:
        return _buildDeniedChip(context);
      default:
        return const Center();
    }
  }

  Widget _buildAwaitingPaymentChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Awaiting Payment',
      leadingIcon: Icons.payment,
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
    );
  }

  Widget _buildPendingChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Pending',
      leadingIcon: Icons.pending_outlined,
      backgroundColor: theme.colorScheme.tertiaryContainer,
      foregroundColor: theme.colorScheme.onTertiaryContainer,
    );
  }

  Widget _buildDeniedChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Denied',
      leadingIcon: Icons.cancel,
      backgroundColor: theme.colorScheme.errorContainer,
      foregroundColor: theme.colorScheme.onErrorContainer,
    );
  }

  Widget _buildPaidChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Paid',
      leadingIcon: Icons.check,
      backgroundColor: theme.colorScheme.secondaryContainer,
      foregroundColor: theme.colorScheme.onSecondaryContainer,
    );
  }
}
