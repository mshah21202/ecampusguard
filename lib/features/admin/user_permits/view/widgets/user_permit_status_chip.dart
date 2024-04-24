import 'package:ecampusguard/global/widgets/raw_status_chip.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class UserPermitStatusChip extends StatelessWidget {
  const UserPermitStatusChip({super.key, required this.status});

  final UserPermitStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case UserPermitStatus.Valid:
        return _buildValidChip(context);
      case UserPermitStatus.Expired:
        return _buildExpiredChip(context);
      case UserPermitStatus.Withdrawn:
        return _buildWithdrawnChip(context);
      default:
        return const Center();
    }
  }

  Widget _buildValidChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Valid',
      leadingIcon: Icons.check,
      backgroundColor: theme.colorScheme.secondaryContainer,
      foregroundColor: theme.colorScheme.onSecondaryContainer,
    );
  }

  Widget _buildExpiredChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Expired',
      leadingIcon: Icons.alarm,
      backgroundColor: theme.colorScheme.errorContainer,
      foregroundColor: theme.colorScheme.onErrorContainer,
    );
  }

  Widget _buildWithdrawnChip(BuildContext context) {
    var theme = Theme.of(context);
    return RawStatusChip(
      label: 'Withdrawn',
      leadingIcon: Icons.error_outline,
      backgroundColor: theme.colorScheme.errorContainer,
      foregroundColor: theme.colorScheme.onErrorContainer,
    );
  }
}
