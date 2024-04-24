import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';

class FormFields extends StatelessWidget {
  const FormFields({
    super.key,
    required this.title,
    required this.children,
    required this.gap,
    this.singleColumn = false,
  });

  final String title;
  final List<Widget> children;
  final double gap;
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.background,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.colorScheme.onBackground),
          ),
          singleColumn
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: gap),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: children.addElementBetweenElements(
                      SizedBox(
                        height: gap,
                      ),
                    ),
                  ),
                )
              : CustomGridView(
                  gap: gap,
                  singleColumn: singleColumn,
                  children: children,
                )
        ],
      ),
    );
  }
}

class CustomGridView extends StatelessWidget {
  const CustomGridView({
    super.key,
    required this.gap,
    required this.children,
    this.singleColumn = false,
  });

  final double gap;
  final List<Widget> children;
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: gap),
      itemCount: children.length,
      itemBuilder: (context, index) {
        if (index % 2 != 0 && index != 0 && !singleColumn) {
          return Center();
        }

        if (index + 1 < children.length && !singleColumn) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: children[index],
                    );
                  },
                ),
              ),
              SizedBox(
                width: gap,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: children[index + 1],
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return children[index];
        }
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: (singleColumn
              ? gap
              : (index % 2 != 0 && index != 0)
                  ? gap
                  : 0),
        );
      },
    );
  }
}
