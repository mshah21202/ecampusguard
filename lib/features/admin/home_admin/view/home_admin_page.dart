import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_admin.dart';
import 'home_admin_view.dart';

class HomeAdminPage extends StatelessWidget {
  const HomeAdminPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeAdminCubit(),
      child: const HomeAdminView(),
    );
  }
}
