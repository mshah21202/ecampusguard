import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class BackgroundLogo extends StatelessWidget {
  const BackgroundLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Positioned(
      left: -150,
      bottom: -150,
      child: Opacity(
        opacity: 0.2,
        child: AppLogo(
          darkMode: theme.colorScheme.brightness == Brightness.dark,
        ),
      ),
    );
  }
}
