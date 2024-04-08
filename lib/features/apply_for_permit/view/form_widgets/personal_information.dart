import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/services/phone_number_validator.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:multiselect/multiselect.dart';

class PersonalDetailsForm extends StatelessWidget {
  PersonalDetailsForm({
    super.key,
  });

  final GlobalKey dropdownButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var cubit = context.read<ApplyForPermitCubit>();
    // var width = MediaQuery.of(context).size.width;
    return FormFields(
      title: "Personal Details",
      gap: 25,
      children: [
        TextFormField(
          controller: cubit.studentIdController,
          decoration: const InputDecoration(
            label: Text("Student ID"),
            errorStyle: TextStyle(height: 0),
          ),
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            if (!RegExp(r"^\d{8}$").hasMatch(value)) {
              return "Invalid Student Id (eg. 2023XXXX)";
            }
            return null;
          },
        ),
        BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
            builder: (context, state) {
          cubit = context.read<ApplyForPermitCubit>();
          return DropDownMultiSelect(
            validator: (value) {
              if (value == null || value == "") {
                return "This is required";
              }

              return null;
            },
            decoration: const InputDecoration(labelText: "Attending Days"),
            options: cubit.attendingDays,
            selectedValues: cubit.selectedAttendingDays,
            onChanged: (selected) {
              cubit.onChangedAttendingDay(selected);
            },
          );
        }),
        BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
            builder: (context, state) {
          cubit = context.read<ApplyForPermitCubit>();

          return TextFormField(
            controller: cubit.phoneNumberController,
            validator: (value) {
              if (value == null || value == "") {
                return "This is required";
              }
              PhoneNumberValidator validator =
                  GetIt.I.get<PhoneNumberValidator>();
              if (!validator.isPhoneNumberValid(
                  cubit.selectedPhoneCountry!.isoCode, "0$value", false)) {
                return "Invalid format";
              }
              return null;
            },
            decoration: InputDecoration(
              label: const Text("Phone Number"),
              errorStyle: const TextStyle(height: 0),
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.language,
                                            );
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
                                    cubit.setSelectedPhoneCountry(country);
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
          controller: cubit.numberOfCompanionsController,
          decoration: const InputDecoration(
            label: Text("Number of Companions"),
            errorStyle: TextStyle(height: 0),
          ),
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
        ),
        BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
            builder: (context, state) {
          var cubit = context.read<ApplyForPermitCubit>();

          return LayoutBuilder(builder: (context, constraints) {
            return DropdownButtonFormField(
              onChanged: (index) {
                cubit.academicYear = index;
              },
              // expandedInsets: EdgeInsets.zero,
              validator: (value) {
                if (value == null) {
                  return "This is required";
                }
                return null;
              },
              value: cubit.academicYear,
              decoration: const InputDecoration(labelText: "Academic Year"),
              items: List.generate(
                cubit.academicYears.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                        minWidth: constraints.minWidth - 48,
                        maxWidth: constraints.maxWidth - 48),
                    child: Text(
                      cubit.academicYears[index],
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          });
        }),
        BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
            builder: (context, state) {
          var cubit = context.read<ApplyForPermitCubit>();
          return InkWell(
            onTap: () async {
              FilePickerResult? result =
                  await FilePickerWeb.platform.pickFiles(type: FileType.image);
              if (result != null) {
                cubit.selectDrivingLicense(result.files.single);
              }
            },
            child: IgnorePointer(
              child: TextFormField(
                enabled: true,
                controller: cubit.drivingLicenseController,
                validator: (value) {
                  if (value == null ||
                      value == "" ||
                      !cubit.choosenCarRegistration) {
                    return "This is required";
                  }

                  return null;
                },
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                decoration: InputDecoration(
                    labelText: "Driving License",
                    labelStyle:
                        TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    suffixIcon: Icon(
                      Icons.file_upload,
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
              ),
            ),
          );
        }),
      ],
    );
  }
}
