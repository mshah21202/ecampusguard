import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../permit_applications.dart';
import 'permit_applications_view.dart';

class PermitApplicationsPage extends StatelessWidget {
  const PermitApplicationsPage({
    Key? key,
    required this.params,
  }) : super(key: key);

  final PermitApplicationsParams params;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermitApplicationsCubit(params: params),
      child: const PermitApplicationsView(),
    );
  }
}
