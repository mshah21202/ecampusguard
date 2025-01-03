// ignore_for_file: unused_field, must_be_immutable

import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ApplicationFilterDialog extends StatefulWidget {
  const ApplicationFilterDialog({
    super.key,
    this.onSave,
    required this.permits,
    required this.params,
  });

  final void Function(
    String? studentId,
    String? name,
    AcademicYear? academicYear,
    int? permitId,
    PermitApplicationStatus? status,
  )? onSave;

  final List<PermitDto> permits;
  final PermitApplicationsParams params;

  @override
  State<ApplicationFilterDialog> createState() =>
      _ApplicationFilterDialogState();
}

class _ApplicationFilterDialogState extends State<ApplicationFilterDialog> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _permitTypeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  AcademicYear? _academicYear;

  int? _permitId;

  PermitApplicationStatus? _status;

  List<String> get _academicYears => [
        "First Year",
        "Second Year",
        "Third Year",
        "Forth Year",
        "Fifth Year (Engineering Students)"
      ];

  final GlobalKey<FormFieldState> _academicYearKey =
      GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> _statusKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _studentIdController.text = widget.params.studentId ?? "";
    _nameController.text = widget.params.name ?? "";
    _academicYear = widget.params.academicYear;
    _permitId = widget.params.permitId;
    _status = widget.params.status;
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          _nameController.clear();
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                    ListTile(
                      title: LayoutBuilder(builder: (context, constraints) {
                        return DropdownButtonFormField(
                          key: _academicYearKey,
                          onChanged: (index) {
                            _academicYear = AcademicYear.values[index ?? 0];
                          },
                          validator: (value) {
                            if (value == null) {
                              return "This is required";
                            }
                            return null;
                          },
                          value: _academicYear?.index,
                          decoration:
                              const InputDecoration(labelText: "Academic Year"),
                          items: List.generate(
                            AcademicYear.values.length,
                            (index) => DropdownMenuItem(
                              value: index,
                              child: ConstrainedBox(
                                constraints: constraints.copyWith(
                                    minWidth: constraints.minWidth - 48,
                                    maxWidth: constraints.maxWidth - 48),
                                child: Text(
                                  _academicYears[index],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      trailing: TextButton(
                        onPressed: () {
                          _academicYear = null;
                          _academicYearKey.currentState!.didChange(null);
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
                            PermitApplicationStatus.values.length,
                            (index) => Text(
                              PermitApplicationStatus.values[index].name,
                            ),
                          );
                        },
                        items: List.generate(
                          PermitApplicationStatus.values.length - 1,
                          (index) => DropdownMenuItem(
                            value: PermitApplicationStatus.values[index],
                            child: PermitApplicationStatusChip(
                              status: PermitApplicationStatus.values[index],
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
                              _nameController.text,
                              _academicYear,
                              _permitId,
                              _status,
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
                      _nameController.clear();
                      _academicYearKey.currentState!.didChange(null);
                      _academicYear = null;
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
