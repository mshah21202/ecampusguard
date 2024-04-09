import 'dart:ui';

import 'package:flutter/material.dart';

class FullScreenLoadingIndicator extends StatelessWidget {
  const FullScreenLoadingIndicator({super.key, required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 1.2,
          sigmaY: 1.2,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: Color.fromARGB((255 * 0.50).toInt(), 0, 0, 0),
          ),
          child: LinearProgressIndicator(
            minHeight: 3,
            color: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}
