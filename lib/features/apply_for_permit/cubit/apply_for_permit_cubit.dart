import 'package:bloc/bloc.dart';
import 'package:built_collection/src/list.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'apply_for_permit_state.dart';

class ApplyForPermitCubit extends Cubit<ApplyForPermitState> {
  ApplyForPermitCubit() : super(ApplyForPermitInitial());

  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();

  Map<String, bool> _attendingDays = {
    "Sun": false,
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
  };

  List<String> get attendingDays => _attendingDays.keys.toList();

  List<String> selectedAttendingDays = [];

  final TextEditingController attendingDaysController = TextEditingController();

  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController carRegistrationController =
      TextEditingController();
  final TextEditingController selectedCarNationalityController =
      TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController numberOfCompanionsController =
      TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController carMakeController = TextEditingController();
  final TextEditingController carYearController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Country? selectedPhoneCountry;
  Country? selectedCarNationality;
  PermitDto? selectedPermit;

  bool acknowledged = false;
  int? academicYear;
  PlatformFile? drivingLicenseImgFile;
  bool get choosenDrivingLicense => drivingLicenseImgFile != null;
  PlatformFile? carRegistrationImgFile;
  bool get choosenCarRegistration => carRegistrationImgFile != null;
  List<String> get academicYears => [
        "First Year",
        "Second Year",
        "Third Year",
        "Forth Year",
        "Fifth Year (Engineering Students)"
      ];
  List<PermitDto>? permits;
  List<Country> countries = [];

  void setAcknowledged(bool val) {
    acknowledged = val;
    emit(ApplyForPermitUpdated(acknowledged: acknowledged));
  }

  void loadCountries() async {
    emit(LoadingApplyForPermitState());
    countries = await getAllCountries();
    selectedPhoneCountry =
        countries.firstWhere((country) => country.isoCode == "JO");
    emit(LoadedApplyForPermitState());
  }

  void loadPermits() async {
    emit(LoadingApplyForPermitState());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data?.toList();
    }

    emit(LoadedApplyForPermitState());
  }

  void selectPermitType(PermitDto permit) {
    selectedPermit = permit;
    emit(ApplyForPermitUpdated(selectedPermit: selectedPermit));
  }

  void selectDrivingLicense(PlatformFile file) {
    drivingLicenseImgFile = file;
    drivingLicenseController.text = file.name;
    emit(UploadedFile(uploadedFile: drivingLicenseImgFile));
  }

  void selectCarRegistration(PlatformFile file) {
    carRegistrationImgFile = file;
    carRegistrationController.text = file.name;
    emit(UploadedFile(uploadedFile: carRegistrationImgFile));
  }

  void setSelectedPhoneCountry(Country? country) {
    selectedPhoneCountry = country;
    emit(ApplyForPermitUpdated(selectedCountry: selectedPhoneCountry));
  }

  void setSelectedCarNationality(Country country) {
    selectedCarNationality = country;
    emit(ApplyForPermitUpdated(selectedCountry: selectedCarNationality));
  }

  void onChangedAttendingDay(List<String> items) {
    selectedAttendingDays = items;

    _attendingDays.updateAll((key, value) => false);

    for (String day in selectedAttendingDays) {
      _attendingDays[day] = true;
    }

    emit(ApplyForPermitUpdated(attendingDays: selectedAttendingDays));
  }

  Future<void> onSubmit() async {
    emit(LoadingApplyForPermitState());
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      var result = await _api
          .getPermitApplicationApi()
          .permitApplicationApplyPost(
              createPermitApplicationDto: CreatePermitApplicationDto((b) {
        b.academicYear = AcademicYearEnum.values.toList()[academicYear ?? 0];
        b.attendingDays = ListBuilder(_attendingDays.values);
        b.licenseImgPath = drivingLicenseImgFile!.name;
        b.permitId = selectedPermit!.id;
        b.phoneNumber =
            "${selectedPhoneCountry!.phoneCode[0] != "+" ? "+" : ""}${selectedPhoneCountry!.phoneCode}${phoneNumberController.text}";
        b.siblingsCount = int.parse(numberOfCompanionsController.text);
        b.vehicle = VehicleDto((b) {
          b.color = carColorController.text;
          b.make = carMakeController.text;
          b.model = carModelController.text;
          b.nationality = selectedCarNationality!.isoCode;
          b.plateNumber = plateNumberController.text;
          b.registrationDocImgPath = drivingLicenseImgFile!.name;
          b.year = int.parse(carYearController.text);
        }).toBuilder();
      }));

      if (result.data == null) {
        return;
      }
      emit(LoadedApplyForPermitState(
          snackBarMessage: result.data!.message.toString()));
    } catch (e) {
      print(e);
    }
  }

  void disableEditingHandler(String prevStr, TextEditingController controller) {
    controller.text = prevStr;
  }
}
