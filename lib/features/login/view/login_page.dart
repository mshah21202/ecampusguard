import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/cubit/authentication_cubit.dart';
import '../login.dart';
import 'login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authCubit = BlocProvider.of<AuthenticationCubit>(context);
    return Scaffold(
      body: BlocProvider<AuthenticationCubit>.value(
        value: authCubit,
        child: const LoginView(),
      ),
    );
  }
}
