import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEST'),
        backgroundColor: const Color(0xFF504e70),
      ),


    );
  }
}