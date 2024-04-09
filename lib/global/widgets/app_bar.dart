import 'package:ecampusguard/global/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar appBar = AppBar(
  title: const Text("eCampusGuard"),
  centerTitle: true,
  leading: IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () {},
  ),
  actions: [
    IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
    BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        var cubit = context.read<ThemeCubit>();
        return IconButton(
          onPressed: () {
            cubit.toggleTheme();
          },
          icon: Icon(cubit.darkMode ? Icons.light_mode : Icons.dark_mode),
        );
      },
    ),
  ],
);
