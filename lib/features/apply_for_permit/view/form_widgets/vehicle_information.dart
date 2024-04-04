import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
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
    var theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: FormFields(
            title: "Vehicle Details",
            gap: 25,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Car Number Plate")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();
                return DropdownMenu(
                  menuHeight: MediaQuery.of(context).size.height * 0.5,
                  onSelected: (country) {
                    cubit.setSelectedCarNationality(
                        cubit.countries.firstWhere((c) => c.name == country));
                  },
                  expandedInsets: EdgeInsets.zero,
                  label: const Text("Car Nationality"),
                  controller: cubit.selectedCarNationalityController,
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
                decoration:
                    const InputDecoration(label: Text("Car Make (Company)")),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Year of Production")),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Car Model")),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Color")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();
                return InkWell(
                  onTap: () async {
                    FilePickerResult? result = await FilePickerWeb.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      cubit.selectDrivingLicense(result.files.single);
                    }
                  },
                  child: TextFormField(
                    enabled: false,
                    controller: cubit.drivingLicenseController,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                    decoration: InputDecoration(
                        labelText: "Valid Car Registration",
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
