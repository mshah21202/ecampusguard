// ignore_for_file: unused_field, must_be_immutable

import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/global/helpers/user_permits_params.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserPermitFilterDialog extends StatefulWidget {
  const UserPermitFilterDialog({
    super.key,
    this.onSave,
    required this.permits,
    required this.params,
  });

  final void Function(
    String? studentId,
    String? plateNumber,
    UserPermitStatus? status,
    int? permitId,
  )? onSave;

  final List<PermitDto> permits;
  final UserPermitsParams params;

  @override
  State<UserPermitFilterDialog> createState() => _UserPermitFilterDialogState();
}

class _UserPermitFilterDialogState extends State<UserPermitFilterDialog> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _permitTypeController = TextEditingController();
  int? _permitId;

  UserPermitStatus? _status;

  final GlobalKey<FormFieldState> _statusKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _studentIdController.text = widget.params.studentId ?? "";
    _plateNumberController.text = widget.params.plateNumber ?? "";
    _status = widget.params.status;
    _permitId = widget.params.permitId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width *
            (ResponsiveWidget.isLargeScreen(context) ? 0.3 : 0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Options",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          labelText: "Student ID",
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _studentIdController.clear();
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: _plateNumberController,
                        decoration: const InputDecoration(
                          labelText: "Plate Number",
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _plateNumberController.clear();
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                    ListTile(
                      title: DropdownMenu(
                        initialSelection: widget.permits
                            .indexWhere((permit) => permit.id == _permitId),
                        expandedInsets: EdgeInsets.zero,
                        label: const Text("Permit Type"),
                        onSelected: (index) {
                          _permitId = widget.permits[index ?? 0].id;
                        },
                        controller: _permitTypeController,
                        dropdownMenuEntries: List.generate(
                          widget.permits.length,
                          (index) => DropdownMenuEntry(
                              value: index,
                              label: widget.permits[index].name ?? ""),
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _permitId = null;
                          _permitTypeController.clear();
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                    ListTile(
                      title: DropdownButtonFormField(
                        key: _statusKey,
                        value: _status,
                        decoration: const InputDecoration(
                          labelText: "Status",
                        ),
                        selectedItemBuilder: (context) {
                          return List.generate(
                            UserPermitStatus.values.length,
                            (index) => Text(
                              UserPermitStatus.values[index].name,
                            ),
                          );
                        },
                        items: List.generate(
                          UserPermitStatus.values.length - 1,
                          (index) => DropdownMenuItem(
                            value: UserPermitStatus.values[index],
                            child: UserPermitStatusChip(
                              status: UserPermitStatus.values[index],
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _status = value;
                        },
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _status = null;
                          _statusKey.currentState!.didChange(null);
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          if (widget.onSave != null) {
                            context.pop();

                            widget.onSave!(
                              _studentIdController.text,
                              _plateNumberController.text,
                              _status,
                              _permitId,
                            );
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text("Apply"),
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.close),
                        label: const Text("Cancel"),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _studentIdController.clear();
                      _plateNumberController.clear();
                      _permitId = null;
                      _permitTypeController.clear();
                      _statusKey.currentState!.didChange(null);
                      _status = null;
                    },
                    child: const Text("Clear All"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
