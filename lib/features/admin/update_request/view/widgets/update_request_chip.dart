import 'package:ecampusguard/global/widgets/raw_status_chip.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart'; 
import 'package:flutter/material.dart';

class UpdateRequestStatusChip extends StatelessWidget {
  const UpdateRequestStatusChip({super.key, required this.status});

  final UpdateRequestStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case UpdateRequestStatus.Pending:
        return _buildPendingChip(context);
      case UpdateRequestStatus.Accepted:
        return _buildAcceptedChip(context);
      case UpdateRequestStatus.Denied:
        return _buildDeniedChip(context);
      default:
        return const Center(); 
    }
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

  Widget _buildAcceptedChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Accepted',
      leadingIcon: Icons.check_circle_outline,
      backgroundColor: theme.colorScheme.primaryContainer,
      foregroundColor: theme.colorScheme.onPrimaryContainer,
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
}
