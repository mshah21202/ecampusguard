import 'package:country_state_city/models/country.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class VehicleInformationDetails extends StatefulWidget {
  const VehicleInformationDetails({
    super.key,
    required this.userPermit,
    required this.countries,
  });

  final UserPermitDto userPermit;
  final List<Country> countries;

  @override
  State<VehicleInformationDetails> createState() =>
      VehicleInformationDetailsState();
}

class VehicleInformationDetailsState extends State<VehicleInformationDetails> {
  @override
  void initState() {
    super.initState();
    populateVehicleInformation();
  }

  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController selectedCarNationalityController =
      TextEditingController();
  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController carRegistrationController =
      TextEditingController();

  PlatformFile? carRegistrationFile;
  String? carRegistrationImgUrl;
  Country? selectedCarNationality;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                        controller: plateNumberController,
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
                        menuHeight: MediaQuery.of(context).size.height * 0.5,
                        onSelected: (country) {
                          setSelectedCarNationality(
                            widget.countries
                                .firstWhere((c) => c.name == country),
                          );
                        },
                        expandedInsets: EdgeInsets.zero,
                        label: const Text("Car Nationality"),
                        controller: selectedCarNationalityController,
                        enableFilter: true,
                        leadingIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: selectedCarNationality != null
                                ? Image.network(
                                    "https://flagsapi.com/${selectedCarNationality!.isoCode}/flat/64.png")
                                : const Icon(Icons.language),
                          ),
                        ),
                        dropdownMenuEntries: List.generate(
                            widget.countries.length,
                            (index) => DropdownMenuEntry(
                                  value: widget.countries[index].name,
                                  label: widget.countries[index].name,
                                  labelWidget: Row(
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Image.network(
                                          "https://flagsapi.com/${widget.countries[index].isoCode}/flat/64.png",
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.language);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.countries[index].name,
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
                        controller: carMakeController,
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
                        controller: carYearController,
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
                        controller: carModelController,
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
                        controller: carColorController,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This is required";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(label: Text("Color")),
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
                    // Download only
                  },
                  child: IgnorePointer(
                    child: TextFormField(
                      enabled: true,
                      controller: carRegistrationController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "This is required";
                        }

                        return null;
                      },
                      style:
                          TextStyle(color: theme.colorScheme.onSurfaceVariant),
                      decoration: InputDecoration(
                          labelText: "Valid Car Registration",
                          labelStyle: TextStyle(
                              color: theme.colorScheme.onSurfaceVariant),
                          suffixIcon: Icon(
                            Icons.file_download,
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
  }

  void populateVehicleInformation() {
    plateNumberController.text = widget.userPermit.vehicle!.plateNumber;
    setSelectedCarNationality(
      widget.countries.firstWhere((element) =>
          element.isoCode == widget.userPermit.vehicle!.nationality),
    );
    carMakeController.text = widget.userPermit.vehicle!.make;
    carModelController.text = widget.userPermit.vehicle!.model;
    carYearController.text = (widget.userPermit.vehicle!.year).toString();
    carColorController.text = widget.userPermit.vehicle!.color;

    carRegistrationController.text = _getFileName(
            Uri(path: widget.userPermit.vehicle!.registrationDocImgPath!)) ??
        "";
    carRegistrationImgUrl = widget.userPermit.vehicle!.registrationDocImgPath;
  }

  void setSelectedCarNationality(Country? country) {
    selectedCarNationality = country;
    selectedCarNationalityController.text = country?.name ?? "";
  }

  String? _getFileName(Uri uri) {
    var regex = RegExp(r'([^\/?%]*\.(?:jpg|jpeg|png|gif|pdf))');

    for (String segment in uri.pathSegments) {
      if (regex.hasMatch(segment)) {
        return segment;
      }
    }

    return null;
  }
}
