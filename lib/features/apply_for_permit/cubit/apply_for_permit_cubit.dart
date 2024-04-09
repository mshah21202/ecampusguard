import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:dio/dio.dart';
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
    emit(const LoadedApplyForPermitState());
  }

  void loadPermits() async {
    emit(LoadingApplyForPermitState());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data?.toList();
    }

    emit(const LoadedApplyForPermitState());
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

  void testSnackBar() {
    emit(const LoadedApplyForPermitState(snackBarMessage: "Test"));
  }

  Future<void> onSubmit() async {
    emit(LoadingApplyForPermitState());
    if (!formKey.currentState!.validate() && !acknowledged) {
      emit(const FailedApplyForPermitState(
          snackBarMessage: "Please fill in the required fields"));
      return;
    }

    try {
      var result = await _api.getPermitApplicationApi().permitApplicationApplyPost(
          createPermitApplicationDto: CreatePermitApplicationDto(
              academicYear: AcademicYearEnum.values.toList()[academicYear ?? 0],
              attendingDays: _attendingDays.values.toList(),
              licenseImgPath: drivingLicenseImgFile!.name,
              permitId: selectedPermit!.id,
              phoneNumber:
                  "${selectedPhoneCountry!.phoneCode[0] != "+" ? "+" : ""}${selectedPhoneCountry!.phoneCode}${phoneNumberController.text}",
              siblingsCount: int.parse(numberOfCompanionsController.text),
              vehicle: VehicleDto(
                  color: carColorController.text,
                  make: carMakeController.text,
                  model: carModelController.text,
                  nationality: selectedCarNationality!.isoCode,
                  plateNumber: plateNumberController.text,
                  registrationDocImgPath: drivingLicenseImgFile!.name,
                  year: int.parse(carYearController.text))));

      if (result.data == null) {
        emit(FailedApplyForPermitState(snackBarMessage: result.statusMessage));
        return;
      } else if (result.data!.responseCode == ResponseCodeEnum.Failed) {
        emit(FailedApplyForPermitState(
            snackBarMessage: result.data!.message.toString()));
        return;
      }

      emit(LoadedApplyForPermitState(
          snackBarMessage: result.data!.message.toString()));
    } catch (e) {
      if (e is DioException && (e).response != null) {
        emit(
          FailedApplyForPermitState(
            snackBarMessage: (ResponseDto.fromJson((e).response!.data))
                .toString(), // TODO: Test this
          ),
        );
      }
    }
  }

  void disableEditingHandler(String prevStr, TextEditingController controller) {
    controller.text = prevStr;
  }
}
