import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_gatestaff.dart';
import 'home_gatestaff_view.dart';

class HomeGatestaffPage extends StatelessWidget {
  const HomeGatestaffPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeGatestaffCubit(),
      child: const HomeGatestaffView(),
    );
  }
}
