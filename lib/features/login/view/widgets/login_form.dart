import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/login/cubit/login_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    // Controllers

    var loginCubit = context.read<LoginCubit>();
    var authCubit = context.read<AuthenticationCubit>();
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenSize.width > 600 ? 400 : screenSize.width * 0.9,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15.0,
                  ),
                ],
              ),
              child: Form(
                key: loginCubit.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/ecampusLogo.png',
                      width: 100,
                      height: 100,
                    ),
                    const Text(
                      'Login to eCampusGuard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        TextFormField(
                          controller: loginCubit.usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value == "") {
                              return "This is required";
                            }

                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        TextFormField(
                          controller: loginCubit.passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator: (value) {
                            if (value == null || value == "") {
                              return "This is required";
                            }

                            return null;
                          },
                          onFieldSubmitted: (value) {
                            onSubmit(
                              loginCubit: loginCubit,
                              authCubit: authCubit,
                            );
                          },
                        ),
                      ].addElementBetweenElements(
                        const SizedBox(
                          height: 10,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: (screenSize.width > 600
                                  ? 400
                                  : screenSize.width * 0.9) *
                              0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          FilledButton.icon(
                            onPressed: () {
                              onSubmit(
                                loginCubit: loginCubit,
                                authCubit: authCubit,
                              );
                            },
                            icon: const Icon(Icons.login),
                            label: const Text('Login'),
                          ),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              GoRouter.of(context).push(registerRoute);
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Register'),
                          ),
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 10,
                          ),
                        ),
                      ),
                    ),
                  ].addElementBetweenElements(
                    const SizedBox(
                      height: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit({
    required LoginCubit loginCubit,
    required AuthenticationCubit authCubit,
  }) {
    if (!loginCubit.formKey.currentState!.validate()) {
      return;
    }
    authCubit.login(
      username: loginCubit.usernameController.text,
      password: loginCubit.passwordController.text,
    );
  }
}
