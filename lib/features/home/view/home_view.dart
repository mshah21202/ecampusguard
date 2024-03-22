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
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TEST",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF565992),
      ),
      body: Stack(
        children: [
        Positioned(
        left: -150,
        bottom: -150,

        child: Opacity(
          opacity: 0.2,
          child: Image.asset(
            'assets/images/ecampusLogo.png',
            /*   fit: BoxFit.cover,*/
/*                width: screenSize.width * 0.5,
                height: screenSize.height * 0.5,*/
          ),
        ),
      ),

    ]
      )
    );
  }
}