import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/login/view/widgets/login_form.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("eCampusGuard"),
            centerTitle: true,
          ),
          // backgroundColor: theme.colorScheme.background,
          body: Stack(
            children: [
              const BackgroundLogo(),
              const LoginForm(),
              FullScreenLoadingIndicator(
                  visible: state is LoadingAuthentication)
            ],
          ),
        );
      },
      listener: (BuildContext context, AuthenticationState state) {
        if (state is LoginFailedAuthentication && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar((state).message!, context),
          );
        }
      },
    );
  }
}
