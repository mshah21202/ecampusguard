import 'package:flutter/material.dart';

class DaysIndicator extends StatelessWidget {
  const DaysIndicator({super.key, required this.days});

  final List<bool> days;

  @override
  Widget build(BuildContext context) {
    List<String> dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu"];
    var theme = Theme.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: dayNames.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color:
                  days[index] ? theme.colorScheme.primary : Colors.transparent,
              border: days[index]
                  ? null
                  : Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              dayNames[index],
              style: TextStyle(
                color: days[index]
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.outline,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
      ),
    );
  }
}
