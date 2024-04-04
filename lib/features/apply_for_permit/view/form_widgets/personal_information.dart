import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/widgets/multi_select_dropdown_menu.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalDetailsForm extends StatelessWidget {
  const PersonalDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: FormFields(
            title: "Personal Details",
            gap: 25,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Student ID")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();
                return MultiSelectDropdownMenu(
                  onSelected: (index) {
                    cubit.onChangedAttendingDay(index ?? 0);
                  },
                  controller: cubit.attendingDaysController,
                  dropdownMenuEntries: cubit.daysNames,
                  selected: cubit.attendingDays,
                );
              }),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();

                return TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Phone Number"),
                    prefixText: cubit.selectedPhoneCountry != null &&
                            cubit.selectedPhoneCountry!.phoneCode.isNotEmpty
                        ? "${cubit.selectedPhoneCountry!.phoneCode[0] != "+" ? "+" : ""}${cubit.selectedPhoneCountry!.phoneCode} "
                        : null,
                    prefixIcon: SizedBox(
                        width: 24,
                        child: IconButton(
                          icon: cubit.selectedPhoneCountry != null
                              ? Image.network(
                                  "https://flagsapi.com/${cubit.selectedPhoneCountry!.isoCode}/flat/64.png")
                              : const Icon(Icons.language),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fill,
                              items: cubit.countries
                                  .map((country) => PopupMenuItem(
                                        value: country.isoCode,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: Image.network(
                                                "https://flagsapi.com/${country.isoCode}/flat/64.png",
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Icon(
                                                      Icons.language);
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                "${country.name} (${country.phoneCode.isNotEmpty && country.phoneCode[0] != "+" ? "+" : ""}${country.phoneCode})",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          cubit
                                              .setSelectedPhoneCountry(country);
                                        },
                                      ))
                                  .toList(),
                            );
                          },
                        )),
                  ),
                );
              }),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Number of Siblings")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();

                return DropdownMenu(
                  onSelected: (index) {
                    cubit.academicYear = index;
                    cubit.academicYearController.text =
                        index != null ? cubit.academicYears[index] : "";
                  },
                  controller: cubit.academicYearController,
                  expandedInsets: EdgeInsets.zero,
                  label: const Text("Academic Year"),
                  dropdownMenuEntries: List.generate(
                    cubit.academicYears.length,
                    (index) => DropdownMenuEntry(
                      value: index,
                      label: cubit.academicYears[index],
                    ),
                  ),
                );
              }),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();
                return InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePickerWeb.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      cubit.selectCarRegistration(result.files.single);
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: cubit.carRegistrationController,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    decoration: InputDecoration(
                        labelText: "Driving License",
                        labelStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant),
                        suffixIcon: Icon(
                          Icons.file_upload,
                          color: theme.colorScheme.onSurfaceVariant,
                        )),
                  ),
                );
              }),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
