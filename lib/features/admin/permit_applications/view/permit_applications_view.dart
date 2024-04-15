import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../permit_applications.dart';

class PermitApplicationsView extends StatelessWidget {
  const PermitApplicationsView({
    Key? key,
    this.status,
  }) : super(key: key);

  final PermitApplicationStatus? status;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitApplicationsCubit>();
    return Container(
      child: Text(status.toString()),
    );
  }
}
