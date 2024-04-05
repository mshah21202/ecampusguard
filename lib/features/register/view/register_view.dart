import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/register/view/widgets/register_form.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// import '../register.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final cubit = context.read<RegisterCubit>();
    var theme = Theme.of(context);

    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: appBar,
          backgroundColor: theme.colorScheme.background,
          body: Stack(
            children: [
              Positioned(
                left: -150,
                bottom: -150,
                child: Opacity(
                  opacity: 0.2,
                  child: AppLogo(
                    darkMode: theme.colorScheme.brightness == Brightness.dark,
                  ),
                ),
              ),
              const RegisterForm(),
              FullScreenLoadingIndicator(
                  visible: state is LoadingAuthentication)
            ],
          ),
        );
      },
      listener: (BuildContext context, AuthenticationState state) {
        if (state is RegisterFailedAuthentication && state.message != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar((state).message!, context),
          );
        }
      },
    );
  }
}
