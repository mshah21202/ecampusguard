import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../register.dart';
import 'register_view.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterView(),
    );
  }
}
