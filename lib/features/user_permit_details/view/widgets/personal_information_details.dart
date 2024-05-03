import 'package:country_state_city/models/country.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/services/phone_number_validator.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PersonalInformationDetails extends StatefulWidget {
  const PersonalInformationDetails({
    super.key,
    required this.userPermit,
    required this.countries,
  });

  final UserPermitDto userPermit;
  final List<Country> countries;

  @override
  State<PersonalInformationDetails> createState() =>
      PersonalInformationDetailsState();
}

class PersonalInformationDetailsState
    extends State<PersonalInformationDetails> {
  @override
  void initState() {
    super.initState();

    populatePersonalInformation();
  }

  Country? selectedPhoneCountry;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController drivingLicenseController =
      TextEditingController();
  PlatformFile? drivingLicenseFile;
  String? drivingLicenseImgUrl;

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
        children: <Widget>[
          Text(
            "Personal Information",
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
                        controller: phoneNumberController,
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This is required";
                          }
                          PhoneNumberValidator validator =
                              GetIt.I.get<PhoneNumberValidator>();
                          if (!validator.isPhoneNumberValid(
                              widget.userPermit.permitApplication!
                                  .phoneNumberCountry!,
                              "0$value",
                              true)) {
                            return "Invalid format";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text("Phone Number"),
                          errorStyle: const TextStyle(height: 0),
                          prefixText: selectedPhoneCountry != null &&
                                  selectedPhoneCountry!.phoneCode.isNotEmpty
                              ? "${selectedPhoneCountry!.phoneCode[0] != "+" ? "+" : ""}${selectedPhoneCountry!.phoneCode} "
                              : null,
                          prefixIcon: SizedBox(
                            width: 24,
                            child: IconButton(
                              icon: selectedPhoneCountry != null
                                  ? Image.network(
                                      "https://flagsapi.com/${selectedPhoneCountry!.isoCode}/flat/64.png")
                                  : const Icon(Icons.language),
                              onPressed: () {
                                showMenu(
                                  context: context,
                                  position: RelativeRect.fill,
                                  items: widget.countries
                                      .map((country) => PopupMenuItem(
                                            value: country.isoCode,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: Image.network(
                                                    "https://flagsapi.com/${country.isoCode}/flat/64.png",
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              setSelectedPhoneCountry(country);
                                            },
                                          ))
                                      .toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          FilePickerResult? result = await FilePickerWeb
                              .platform
                              .pickFiles(type: FileType.image);

                          if (result != null) {
                            selectDrivingLicense(result.files.single);
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            enabled: true,
                            controller: drivingLicenseController,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "This is required";
                              }

                              return null;
                            },
                            style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant),
                            decoration: InputDecoration(
                                labelText: "Driving License",
                                labelStyle: TextStyle(
                                    color: theme.colorScheme.onSurfaceVariant),
                                suffixIcon: Icon(
                                  Icons.file_upload,
                                  color: theme.colorScheme.onSurfaceVariant,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ].addElementBetweenElements(
                    SizedBox(
                      width: ResponsiveWidget.smallPadding(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void populatePersonalInformation() {
    setSelectedPhoneCountry(
      widget.countries.firstWhere((element) =>
          element.isoCode ==
          widget.userPermit.permitApplication!.phoneNumberCountry!),
    );

    phoneNumberController.text =
        widget.userPermit.permitApplication!.phoneNumber!;
  }

  void setSelectedPhoneCountry(Country? country) {
    selectedPhoneCountry = country;
  }

  void selectDrivingLicense(PlatformFile file) {
    drivingLicenseFile = file;
    drivingLicenseController.text = file.name;
  }
}
