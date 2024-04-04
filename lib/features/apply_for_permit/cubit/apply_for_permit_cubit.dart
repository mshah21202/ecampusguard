import 'package:bloc/bloc.dart';
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
    "Thu": false
  };

  final attendingDaysController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();

  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController carRegistrationController =
      TextEditingController();
  final TextEditingController selectedCarNationalityController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool acknowledged = false;
  int? academicYear;
  PlatformFile? _drivingLicenseImgFile;
  PlatformFile? _carRegistrationImgFile;
  List<bool> get attendingDays => _attendingDays.values.toList();
  List<String> get daysNames => _attendingDays.keys.toList();
  List<String> get academicYears => [
        "First Year",
        "Second Year",
        "Third Year",
        "Forth Year",
        "Fifth Year (Engineering Students)"
      ];
  List<PermitDto>? permits;
  List<Country> countries = [];
  Country? selectedPhoneCountry;
  Country? selectedCarNationality;
  PermitDto? selectedPermit;

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
    _drivingLicenseImgFile = file;
    drivingLicenseController.text = file.name;
    emit(UploadedFile(uploadedFile: _drivingLicenseImgFile));
  }

  void selectCarRegistration(PlatformFile file) {
    _carRegistrationImgFile = file;
    carRegistrationController.text = file.name;
    emit(UploadedFile(uploadedFile: _carRegistrationImgFile));
  }

  void setSelectedPhoneCountry(Country country) {
    selectedPhoneCountry = country;
    emit(ApplyForPermitUpdated(selectedCountry: selectedPhoneCountry));
  }

  void setSelectedCarNationality(Country country) {
    selectedCarNationality = country;
    emit(ApplyForPermitUpdated(selectedCountry: selectedCarNationality));
  }

  void handleAttendingDays() {
    _setAttendingDaysText();
  }

  void _setAttendingDaysText() {
    Map<String, bool> days = Map<String, bool>.from(_attendingDays);
    days.removeWhere((key, value) => !value);

    List<String> daysStrings = days.keys.toList();

    attendingDaysController.text = daysStrings.join(',');
  }

  void onChangedAttendingDay(int index) {
    _attendingDays[_attendingDays.keys.elementAt(index)] =
        !_attendingDays[_attendingDays.keys.elementAt(index)]!;

    _setAttendingDaysText();
    emit(ApplyForPermitUpdated(attendingDays: _attendingDays.values.toList()));
  }
}
