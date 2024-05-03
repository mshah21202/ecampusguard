import 'package:flutter/material.dart';

class ErrorFilledButton extends StatelessWidget {
  const ErrorFilledButton({
    super.key,
    required Widget child,
    required this.onPressed,
  })  : _tonal = false,
        _label = child,
        _icon = null;

  const ErrorFilledButton.icon({
    super.key,
    required Widget label,
    required Widget icon,
    required this.onPressed,
  })  : _tonal = true,
        _label = label,
        _icon = icon;

  const ErrorFilledButton.tonal({
    super.key,
    required Widget label,
    required this.onPressed,
  })  : _tonal = true,
        _label = label,
        _icon = null;

  const ErrorFilledButton.tonalIcon({
    super.key,
    required Widget label,
    required Widget icon,
    required this.onPressed,
  })  : _tonal = true,
        _label = label,
        _icon = icon;

  final Widget _label;
  final Widget? _icon;
  final bool _tonal;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    var theme = Theme.of(context);
    if (_icon != null) {
      return FilledButton.icon(
        style: FilledButton.styleFrom(
          foregroundColor: _tonal
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onError,
          backgroundColor: _tonal
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.error,
        ),
        onPressed: onPressed,
        label: _label,
        icon: _icon,
      );
    } else {
      return FilledButton(
        style: FilledButton.styleFrom(
          foregroundColor: _tonal
              ? theme.colorScheme.onErrorContainer
              : theme.colorScheme.onError,
          backgroundColor: _tonal
              ? theme.colorScheme.errorContainer
              : theme.colorScheme.error,
        ),
        onPressed: onPressed,
        child: _label,
      );
    }
  }
}
