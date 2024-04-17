import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:dio/dio.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'applications_review_state.dart';

class ApplicationsReviewCubit extends Cubit<ApplicationsReviewState> {
  ApplicationsReviewCubit({required this.applicationId})
      : super(ApplicationsReviewInitial()) {
    populateFields();
  }

  final int applicationId;

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
  PermitApplicationDto? permitApplication;

  TextEditingController selectedPermitController = TextEditingController();

  Future<void> _getPermitApplication() async {
    emit(LoadingApplicationsReviewState());
    try {
      var result = await _api
          .getPermitApplicationApi()
          .permitApplicationIdGet(id: applicationId);

      if (result.data != null) {
        emit(const LoadedApplicationsReviewState());
        permitApplication = result.data!;
      }
    } catch (e) {
      emit(FailedApplicationsReviewState(snackBarMessage: e.toString()));
    }
  }

  void populateFields() async {
    await _getPermitApplication();
    await loadCountries();
    await loadPermits();
    if (permitApplication != null) {
      studentIdController.text = permitApplication!.studentId!.toString();

      Map<String, bool> attendingDays = {
        "Sun": permitApplication!.attendingDays!.elementAtOrNull(0) ?? false,
        "Mon": permitApplication!.attendingDays!.elementAtOrNull(1) ?? false,
        "Tue": permitApplication!.attendingDays!.elementAtOrNull(2) ?? false,
        "Wed": permitApplication!.attendingDays!.elementAtOrNull(3) ?? false,
        "Thu": permitApplication!.attendingDays!.elementAtOrNull(4) ?? false,
      };

      _attendingDays = Map.from(attendingDays);

      selectedAttendingDays = _attendingDays.entries
          .where((element) => element.value)
          .map((e) => e.key)
          .toList();

      attendingDaysController.text = selectedAttendingDays.join(",");

      setSelectedCarNationality((await getCountryFromCode(
          permitApplication!.vehicle!.nationality!))!);
      selectPermitType(permitApplication!.permit!);

      phoneNumberController.text =
          (permitApplication!.phoneNumber!).substring(0);

      numberOfCompanionsController.text =
          permitApplication!.siblingsCount!.toString();

      plateNumberController.text = permitApplication!.vehicle!.plateNumber!;

      academicYear = permitApplication!.academicYear!.index;

      selectPermitType(permits!.firstWhere(
          (element) => element.id == permitApplication!.permit!.id,
          orElse: () => permits!.first));

      carMakeController.text = permitApplication!.vehicle!.make!;
      carModelController.text = permitApplication!.vehicle!.model!;
      carColorController.text = permitApplication!.vehicle!.color!;
      carYearController.text = permitApplication!.vehicle!.year!.toString();
    }
  }

  void setAcknowledged(bool val) {
    acknowledged = val;
    emit(ApplicationsReviewUpdated(acknowledged: acknowledged));
  }

  Future<void> loadCountries() async {
    emit(LoadingApplicationsReviewState());
    countries = await getAllCountries();
    selectedPhoneCountry =
        countries.firstWhere((country) => country.isoCode == "JO");
    emit(const LoadedApplicationsReviewState());
  }

  Future<void> loadPermits() async {
    emit(LoadingApplicationsReviewState());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data?.toList();
    }

    emit(const LoadedApplicationsReviewState());
  }

  void selectPermitType(PermitDto permit) {
    selectedPermit = permit;
    selectedPermitController.text = selectedPermit!.name!;
    emit(ApplicationsReviewUpdated(selectedPermit: selectedPermit));
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

  void setSelectedPhoneCountry(Country? country) async {
    if (countries.isEmptyOrNull) {
      await loadCountries();
    }
    selectedPhoneCountry = country;
    emit(ApplicationsReviewUpdated(selectedCountry: selectedPhoneCountry));
  }

  void setSelectedCarNationality(Country country) async {
    if (countries.isEmptyOrNull) {
      await loadCountries();
    }
    selectedCarNationality = country;
    selectedCarNationalityController.text = selectedCarNationality!.name;
    emit(ApplicationsReviewUpdated(selectedCountry: selectedCarNationality));
  }

  void onChangedAttendingDay(List<String> items) {
    selectedAttendingDays = items;

    _attendingDays.updateAll((key, value) => false);

    for (String day in selectedAttendingDays) {
      _attendingDays[day] = true;
    }

    emit(ApplicationsReviewUpdated(attendingDays: selectedAttendingDays));
  }

  void testSnackBar() {
    emit(const LoadedApplicationsReviewState(snackBarMessage: "Test"));
  }

  Future<void> onSubmit() async {
    emit(LoadingApplicationsReviewState());
    if (!formKey.currentState!.validate() && !acknowledged) {
      emit(const FailedApplicationsReviewState(
          snackBarMessage: "Please fill in the required fields"));
      return;
    }

    try {
      var result = await _api.getPermitApplicationApi().permitApplicationApplyPost(
          createPermitApplicationDto: CreatePermitApplicationDto(
              academicYear: AcademicYear.values.toList()[academicYear ?? 0],
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
        emit(FailedApplicationsReviewState(
            snackBarMessage: result.statusMessage));
        return;
      } else if (result.data!.responseCode == ResponseCode.Failed) {
        emit(FailedApplicationsReviewState(
            snackBarMessage: result.data!.message.toString()));
        return;
      }

      emit(LoadedApplicationsReviewState(
          snackBarMessage: result.data!.message.toString()));
    } catch (e) {
      if (e is DioException && (e).response != null) {
        emit(
          FailedApplicationsReviewState(
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
