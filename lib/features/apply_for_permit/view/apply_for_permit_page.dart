import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../apply_for_permit.dart';
import 'apply_for_permit_view.dart';

class ApplyForPermitPage extends StatelessWidget {
  const ApplyForPermitPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApplyForPermitCubit(),
      child: const ApplyForPermitView(),
    );
  }
}
