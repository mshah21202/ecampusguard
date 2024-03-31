import 'package:flutter/material.dart';

class FormFields extends StatelessWidget {
  const FormFields(
      {super.key,
      required this.title,
      required this.children,
      required this.gap});

  final String title;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.colorScheme.onBackground),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: gap),
            itemCount: children.length,
            itemBuilder: (context, index) {
              if (index % 2 != 0 && index != 0) {
                return Center();
              }

              if (index + 1 < children.length) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: children[index]),
                    SizedBox(
                      width: gap,
                    ),
                    Expanded(child: children[index + 1]),
                  ],
                );
              } else {
                return children[index];
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: index % 2 != 0 && index != 0 ? gap : 0,
              );
            },
          )
        ],
      ),
    );
  }
}
