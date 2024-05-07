import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:multiselect/multiselect.dart';

import '../permits.dart';

class PermitDetailsView extends StatefulWidget {
  const PermitDetailsView({
    Key? key,
    this.permitId,
  })  : _isCreating = permitId == null,
        super(key: key);

  final int? permitId;
  final bool _isCreating;

  @override
  State<PermitDetailsView> createState() => _PermitDetailsViewState();
}

class _PermitDetailsViewState extends State<PermitDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PermitsCubit>();
    if (!widget._isCreating) {
      cubit.getPermit(widget.permitId!);
    } else {
      cubit.populateFields(clear: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitsCubit>();
    var theme = Theme.of(context);
    return Scaffold(
      drawer: const AdminAppDrawer(),
      appBar: appBar(),
      body: BlocBuilder<PermitsCubit, PermitsState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.25,
                    vertical: ResponsiveWidget.smallPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget._isCreating ? "Create" : "Edit"} Permit",
                        style: theme.textTheme.headlineLarge!.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      Form(
                        key: cubit.formKey,
                        child: FormFields(
                          title: "Permit Information",
                          gap: 25,
                          singleColumn: true,
                          children: [
                            TextFormField(
                              controller: cubit.permitNameController,
                              decoration: const InputDecoration(
                                labelText: "Name",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }

                                return null;
                              },
                            ),
                            BlocBuilder<PermitsCubit, PermitsState>(
                                builder: (context, state) {
                              return DropDownMultiSelect(
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "This is required";
                                  }

                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Attending Days",
                                ),
                                options: cubit.permitDays,
                                selectedValues: cubit.selectedDays,
                                onChanged: (selected) {
                                  cubit.onChangedDays(selected);
                                },
                              );
                            }),
                            TextFormField(
                              controller: cubit.permitPriceController,
                              decoration: const InputDecoration(
                                labelText: "Price",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }

                                if (int.tryParse(value) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return "Please enter a valid number (1-9999)";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: cubit.permitCapacityController,
                              decoration: const InputDecoration(
                                labelText: "Capacity",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }

                                if (int.tryParse(value) == null ||
                                    int.tryParse(value)! <= 0) {
                                  return "Please enter a valid number (1-9999)";
                                }
                                return null;
                              },
                            ),
                            InkWell(
                              onTap: () {
                                showDatePicker(
                                  useRootNavigator: false,
                                  context: context,
                                  initialDate: cubit.expiry,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 2),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    cubit.onDateChanged(value);
                                  }
                                });
                              },
                              child: IgnorePointer(
                                child: InputDatePickerFormField(
                                  key: cubit.expiryDateKey,
                                  fieldLabelText: "Expiry",
                                  initialDate: cubit.expiry,
                                  onDateSubmitted: (date) {
                                    cubit.expiry = date;
                                  },
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    const Duration(days: 365 * 2),
                                  ),
                                ),
                              ),
                            ),
                            DropdownButtonFormField(
                              validator: (value) {
                                if (value == null) {
                                  return "This is required";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                labelText: "Area",
                              ),
                              value: cubit.areaIndex,
                              items: List.generate(
                                cubit.areas.length,
                                (index) => DropdownMenuItem(
                                  value: index,
                                  child: Text(cubit.areas[index].name!),
                                ),
                              ).toList(),
                              onChanged: (index) {
                                cubit.areaIndex = index;
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          FilledButton.icon(
                            onPressed: () {
                              cubit
                                  .onSubmit(create: widget._isCreating)
                                  .then((value) {
                                if (value) {
                                  context.pop();
                                }
                              });
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Save Permit"),
                          ),
                          SizedBox(
                            width: ResponsiveWidget.smallPadding(context),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Cancel"),
                          )
                        ],
                      )
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
                  ),
                ),
              ),
              FullScreenLoadingIndicator(visible: state is PermitsLoading)
            ],
          );
        },
      ),
    );
  }
}
