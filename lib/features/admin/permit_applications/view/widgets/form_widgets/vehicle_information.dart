import 'package:ecampusguard/features/admin/permit_applications/permit_applications.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleDetailsForm extends StatelessWidget {
  const VehicleDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<PermitApplicationsCubit>();
    var theme = Theme.of(context);
    return FormFields(
      title: "Vehicle Details",
      gap: 25,
      children: [
        TextFormField(
          controller: cubit.plateNumberController,
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
          decoration: const InputDecoration(label: Text("Car Number Plate")),
        ),
        BlocBuilder<PermitApplicationsCubit, PermitApplicationsState>(
            builder: (context, state) {
          cubit = context.read<PermitApplicationsCubit>();
          return DropdownMenu(
            // TODO: Change this to dropdownbuttonformfield for validator
            menuHeight: MediaQuery.of(context).size.height * 0.5,
            onSelected: (country) {
              cubit.setSelectedCarNationality(
                  cubit.countries.firstWhere((c) => c.name == country));
            },
            expandedInsets: EdgeInsets.zero,
            label: const Text("Car Nationality"),
            controller: cubit.selectedCarNationalityController,
            enableFilter: true,
            leadingIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 24,
                width: 24,
                child: cubit.selectedCarNationality != null
                    ? Image.network(
                        "https://flagsapi.com/${cubit.selectedCarNationality!.isoCode}/flat/64.png")
                    : const Icon(Icons.language),
              ),
            ),
            dropdownMenuEntries: List.generate(
                cubit.countries.length,
                (index) => DropdownMenuEntry(
                      value: cubit.countries[index].name,
                      label: cubit.countries[index].name,
                      labelWidget: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.network(
                              "https://flagsapi.com/${cubit.countries[index].isoCode}/flat/64.png",
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.language);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            cubit.countries[index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )),
          );
        }),
        TextFormField(
          controller: cubit.carMakeController,
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
          decoration: const InputDecoration(label: Text("Car Make (Company)")),
        ),
        TextFormField(
          controller: cubit.carYearController,
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
          decoration: const InputDecoration(label: Text("Year of Production")),
        ),
        TextFormField(
          controller: cubit.carModelController,
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
          decoration: const InputDecoration(label: Text("Car Model")),
        ),
        TextFormField(
          controller: cubit.carColorController,
          validator: (value) {
            if (value == null || value == "") {
              return "This is required";
            }

            return null;
          },
          decoration: const InputDecoration(label: Text("Color")),
        ),
        BlocBuilder<PermitApplicationsCubit, PermitApplicationsState>(
            builder: (context, state) {
          var cubit = context.read<PermitApplicationsCubit>();
          return InkWell(
            onTap: () async {
              FilePickerResult? result =
                  await FilePickerWeb.platform.pickFiles(type: FileType.image);
              if (result != null) {
                cubit.selectCarRegistration(result.files.single);
              }
            },
            child: IgnorePointer(
              child: TextFormField(
                enabled: true,
                controller: cubit.carRegistrationController,
                validator: (value) {
                  // if (value == null || value == "") {
                  //   return "This is required";
                  // }

                  return null;
                },
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                decoration: InputDecoration(
                    labelText: "Valid Car Registration",
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
