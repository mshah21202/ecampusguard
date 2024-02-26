import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../login.dart';
import 'login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginView(),
    );
  }
}
