import 'package:flutter/material.dart';

class BackgroundLogo extends StatelessWidget {
  const BackgroundLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -150,
      bottom: -150,
      child: Opacity(
        opacity: 0.2,
        child: Image.asset(
          'assets/images/ecampusLogo.png',

         /* fit: BoxFit.contain,*/
        ),
      ),
    );
  }
}
