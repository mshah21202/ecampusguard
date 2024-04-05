import 'package:ecampusguard/features/authentication/cubit/authentication_cubit.dart';
import 'package:ecampusguard/features/register/cubit/register_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    // Controllers

    var registerCubit = context.read<RegisterCubit>();
    var authCubit = context.read<AuthenticationCubit>();
    return Center(
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
              key: registerCubit.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/ecampusLogo.png',
                    width: 100,
                    height: 100,
                  ),
                  const Text(
                    'Register in eCampusGuard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: registerCubit.nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This is required";
                          }

                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {},
                      ),
                      TextFormField(
                        controller: registerCubit.usernameController,
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
                        controller: registerCubit.passwordController,
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
                              registerCubit: registerCubit,
                              authCubit: authCubit);
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
                                registerCubit: registerCubit,
                                authCubit: authCubit);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Register'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                          label: const Text('Go Back'),
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
    );
  }

  void onSubmit({
    required RegisterCubit registerCubit,
    required AuthenticationCubit authCubit,
  }) {
    if (!registerCubit.formKey.currentState!.validate()) {
      return;
    }

    authCubit.register(
      name: registerCubit.nameController.text,
      username: registerCubit.usernameController.text,
      password: registerCubit.passwordController.text,
    );
  }
}
