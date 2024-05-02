import 'package:ecampusguard/features/user_permit_details/cubit/user_permit_details_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/services/phone_number_validator.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class PersonalInformationDetails extends StatefulWidget {
  const PersonalInformationDetails({
    super.key,
  });

  @override
  State<PersonalInformationDetails> createState() =>
      _PersonalInformationDetailsState();
}

class _PersonalInformationDetailsState
    extends State<PersonalInformationDetails> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<UserPermitDetailsCubit>();

    cubit.populatePersonalInformation();
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
                          controller: cubit.phoneNumberController,
                          validator: (value) {
                            if (value == null || value == "") {
                              return "This is required";
                            }
                            PhoneNumberValidator validator =
                                GetIt.I.get<PhoneNumberValidator>();
                            if (!validator.isPhoneNumberValid(
                                cubit.userPermit!.permitApplication!
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
                            prefixText: cubit.selectedPhoneCountry != null &&
                                    cubit.selectedPhoneCountry!.phoneCode
                                        .isNotEmpty
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
                                                cubit.setSelectedPhoneCountry(
                                                    country);
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
                              cubit.selectDrivingLicense(result.files.single);
                            }
                          },
                          child: IgnorePointer(
                            child: TextFormField(
                              enabled: true,
                              controller: cubit.drivingLicenseController,
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
                                      color:
                                          theme.colorScheme.onSurfaceVariant),
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
    });
  }
}
