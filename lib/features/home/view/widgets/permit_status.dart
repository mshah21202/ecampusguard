import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

/// This widget displays the permit's status information. It has 3 states, [ValidPermit], [WithdrawnPermit], & [ExpiredPermit].
///
/// Use this if [HomeState]'s [userPermit] is not [null].
class PermitStatusWidget extends StatelessWidget {
  const PermitStatusWidget({super.key, required this.status});

  final UserPermitStatus status;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
