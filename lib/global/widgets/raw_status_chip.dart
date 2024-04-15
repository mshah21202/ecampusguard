import 'package:flutter/material.dart';

class RawStatusChip extends StatelessWidget {
  const RawStatusChip({
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    required this.label,
    required this.leadingIcon,
  });

  final Color? backgroundColor;
  final Color? foregroundColor;
  final String label;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6, right: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              leadingIcon,
              color: foregroundColor,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              label,
              style: TextStyle(
                color: foregroundColor,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
