import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../permit_applications.dart';
import 'permit_applications_view.dart';

class PermitApplicationsPage extends StatelessWidget {
  const PermitApplicationsPage({
    Key? key,
    this.status,
  }) : super(key: key);

  final PermitApplicationStatusEnum? status;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermitApplicationsCubit(),
      child: PermitApplicationsView(
        status: status,
      ),
    );
  }
}
