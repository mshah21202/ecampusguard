import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.darkMode, this.width, this.height});

  final bool darkMode;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      darkMode
          ? 'assets/images/ecampusLogoWhite.png'
          : 'assets/images/ecampusLogo.png',
      width: width,
      height: height,
    );
  }
}
