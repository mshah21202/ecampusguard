import 'package:flutter/material.dart';

class MultiSelectDropdownMenu extends StatelessWidget {
  const MultiSelectDropdownMenu({
    super.key,
    required this.controller,
    required this.onSelected,
    required this.dropdownMenuEntries,
    required this.selected,
  });

  final TextEditingController controller;
  final void Function(int?) onSelected;
  final List<String> dropdownMenuEntries;
  final List<bool> selected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      label: const Text("Attending Days"),
      expandedInsets: EdgeInsets.zero,
      controller: controller,
      enableSearch: false,
      onSelected: onSelected,
      dropdownMenuEntries: List.generate(
        dropdownMenuEntries.length,
        (index) => DropdownMenuEntry(
          leadingIcon: Checkbox(
            value: selected[index],
            onChanged: (value) {
              onSelected(index);
            },
          ),
          label: dropdownMenuEntries[index],
          value: index,
        ),
      ),
    );
  }
}
