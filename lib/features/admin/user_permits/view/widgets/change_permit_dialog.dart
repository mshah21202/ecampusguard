import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePermitDialog extends StatefulWidget {
  const ChangePermitDialog({
    super.key,
    required this.permits,
    this.initialPermitId,
    required this.onSave,
  });

  final List<PermitDto> permits;
  final int? initialPermitId;
  final void Function(int permitId) onSave;

  @override
  State<ChangePermitDialog> createState() => ChangePermitDialogState();
}

class ChangePermitDialogState extends State<ChangePermitDialog> {
  int? permitId;

  @override
  void initState() {
    super.initState();
    permitId = widget.initialPermitId;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Builder(builder: (context) {
      return Dialog(
        child: SizedBox(
          // height: MediaQuery.of(context).size.width * 0.3,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Change Permit",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Text(
                  "Current Permit: ${widget.permits.firstWhere((permit) => permit.id == widget.initialPermitId).name}",
                  style: theme.textTheme.headlineSmall!.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                DropdownMenu(
                  expandedInsets: EdgeInsets.zero,
                  label: const Text("Permit Type"),
                  initialSelection: widget.initialPermitId,
                  onSelected: (id) {
                    permitId = id;
                  },
                  dropdownMenuEntries: List.generate(
                    widget.permits.length,
                    (index) => DropdownMenuEntry(
                      value: widget.permits[index].id,
                      label: widget.permits[index].name ?? "",
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (permitId != null) {
                      widget.onSave(permitId!);
                    }
                    context.pop();
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Save"),
                ),
              ].addElementBetweenElements(
                SizedBox(
                  height: ResponsiveWidget.mediumPadding(context),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
