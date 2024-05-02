import 'package:ecampusguard/features/user_permit_details/cubit/user_permit_details_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleInformationDetails extends StatefulWidget {
  const VehicleInformationDetails({
    super.key,
  });

  @override
  State<VehicleInformationDetails> createState() =>
      _VehicleInformationDetailsState();
}

class _VehicleInformationDetailsState extends State<VehicleInformationDetails> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<UserPermitDetailsCubit>();
    cubit.populateVehicleInformation();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<UserPermitDetailsCubit, UserPermitDetailsState>(
      builder: (context, state) {
        var cubit = context.read<UserPermitDetailsCubit>();
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          padding: EdgeInsets.all(
            ResponsiveWidget.smallPadding(context) + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Vehicle Information",
                style: theme.textTheme.headlineSmall,
              ),
              Padding(
                padding: EdgeInsets.all(
                  ResponsiveWidget.smallPadding(context),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: cubit.plateNumberController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text("Car Number Plate"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: DropdownMenu(
                            menuHeight:
                                MediaQuery.of(context).size.height * 0.5,
                            onSelected: (country) {
                              cubit.setSelectedCarNationality(
                                cubit.countries
                                    .firstWhere((c) => c.name == country),
                              );
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
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return const Icon(
                                                    Icons.language);
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
                          ),
                        ),
                      ].addElementBetweenElements(
                        SizedBox(
                          width: ResponsiveWidget.smallPadding(context),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: cubit.carMakeController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("Car Make (Company)")),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: cubit.carYearController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            decoration: const InputDecoration(
                                label: Text("Year of Production")),
                          ),
                        ),
                      ].addElementBetweenElements(
                        SizedBox(
                          width: ResponsiveWidget.smallPadding(context),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: cubit.carModelController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Car Model")),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: cubit.carColorController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            decoration:
                                const InputDecoration(label: Text("Color")),
                          ),
                        ),
                      ].addElementBetweenElements(
                        SizedBox(
                          width: ResponsiveWidget.smallPadding(context),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        FilePickerResult? result = await FilePickerWeb.platform
                            .pickFiles(type: FileType.image);
                        if (result != null) {
                          cubit.selectCarRegistration(result.files.single);
                        }
                      },
                      child: IgnorePointer(
                        child: TextFormField(
                          enabled: true,
                          controller: cubit.carRegistrationController,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "This is required";
                            }

                            return null;
                          },
                          style: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant),
                          decoration: InputDecoration(
                              labelText: "Valid Car Registration",
                              labelStyle: TextStyle(
                                  color: theme.colorScheme.onSurfaceVariant),
                              suffixIcon: Icon(
                                Icons.file_upload,
                                color: theme.colorScheme.onSurfaceVariant,
                              )),
                        ),
                      ),
                    ),
                  ].addElementBetweenElements(
                    SizedBox(
                      height: ResponsiveWidget.smallPadding(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
