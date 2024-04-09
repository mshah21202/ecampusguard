import 'package:flutter/material.dart';

SnackBar appSnackBar(String content, BuildContext context) {
  return SnackBar(
    content: Text(
      content,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
    ),
    elevation: 12,
    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 25),
    showCloseIcon: true,
    closeIconColor: Theme.of(context).colorScheme.onSurfaceVariant,
  );
}
