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
        title: const Text('eCampusGuard'),
        backgroundColor: const Color(0xFF504e70),
      ),
      body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
          Card(

      ),
      SizedBox(height: 16),
    ]
      )
    );
  }
}