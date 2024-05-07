import 'package:ecampusguard/global/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar appBar({bool automaticallyImplyLeading = false}) => AppBar(
      title: const Text("eCampusGuard"),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
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
