import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

part 'permit_applications_state.dart';

class PermitApplicationsCubit extends Cubit<PermitApplicationsState> {
  PermitApplicationsCubit({required this.params})
      : super(PermitApplicationsInitial()) {
    applicationsDataSource = PermitApplicationsDataSource.fromApi(
      fetchFunction: getPermitApplications,
      cubit: this,
    );

    loadPermits();
  }

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
  int? applicationId;
  bool acknowledged = false;
  int? academicYear;
  Uri? drivingLicenseImgUrl;
  Uri? carRegistrationImgUrl;
  // PlatformFile? drivingLicenseImgFile;
  // bool get choosenDrivingLicense => drivingLicenseImgFile != null;
  // PlatformFile? carRegistrationImgFile;
  // bool get choosenCarRegistration => carRegistrationImgFile != null;
  List<String> get academicYears => [
        "First Year",
        "Second Year",
        "Third Year",
        "Forth Year",
        "Fifth Year (Engineering Students)"
      ];
  List<Country> countries = [];
  PermitApplicationDto? permitApplication;

  TextEditingController selectedPermitController = TextEditingController();

  List<PermitApplicationInfoDto> applications = [];
  List<PermitApplicationInfoDto> selectedApplications = [];
  List<PermitDto> permits = [];
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  late PermitApplicationsDataSource applicationsDataSource;
  PermitApplicationsParams params;
  int? sortColumnIndex;
  int totalRows = 0;
  PaginatorController controller = PaginatorController();

  void selectedRowsListener() {
    selectedApplications =
        applicationsDataSource.selectionState == SelectionState.include
            ? applicationsDataSource.selectionRowKeys
                .map((key) => applications[(key as ValueKey<int>).value])
                .toList()
            : applications.indexed
                .where((element) => !applicationsDataSource.selectionRowKeys
                    .contains(ValueKey(element.$1)))
                .map((e) => e.$2)
                .toList();

    if (applicationsDataSource.selectionState == SelectionState.none) {
      selectedApplications = [];
    }

    emit(PermitApplicationsRowSelection(
        selectedApplications: selectedApplications));
  }

  Future<void> _getPermitApplication() async {
    emit(LoadingPermitApplications());
    try {
      var result = await _api
          .getPermitApplicationApi()
          .permitApplicationIdGet(id: applicationId!);

      if (result.data != null) {
        emit(const LoadedPermitApplications());
        permitApplication = result.data!;
      }
    } catch (e) {
      emit(ErrorPermitApplications(snackBarMessage: e.toString()));
    }
  }

  Future<void> loadCountries() async {
    emit(LoadingPermitApplications());
    countries = await getAllCountries();
    selectedPhoneCountry =
        countries.firstWhere((country) => country.isoCode == "JO");
    emit(const LoadedPermitApplications());
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

      setSelectedCarNationality(
          (await getCountryFromCode(permitApplication!.vehicle!.nationality))!);
      selectPermitType(permitApplication!.permit!);
      setSelectedPhoneCountry(
          (await getCountryFromCode(permitApplication!.phoneNumberCountry!)));

      phoneNumberController.text = permitApplication!.phoneNumber!;

      numberOfCompanionsController.text =
          permitApplication!.siblingsCount!.toString();

      plateNumberController.text = permitApplication!.vehicle!.plateNumber;

      academicYear = permitApplication!.academicYear!.index;

      selectPermitType(permits.firstWhere(
          (element) => element.id == permitApplication!.permit!.id,
          orElse: () => permits.first));

      carMakeController.text = permitApplication!.vehicle!.make;
      carModelController.text = permitApplication!.vehicle!.model;
      carColorController.text = permitApplication!.vehicle!.color;
      carYearController.text = permitApplication!.vehicle!.year.toString();

      drivingLicenseImgUrl = permitApplication!.licenseImgPath != null
          ? Uri.tryParse(permitApplication!.licenseImgPath!)
          : null;
      drivingLicenseController.text = drivingLicenseImgUrl == null
          ? "File not found"
          : _getFileName(drivingLicenseImgUrl!) ?? "File not found";
      carRegistrationImgUrl = permitApplication!
                  .vehicle!.registrationDocImgPath !=
              null
          ? Uri.tryParse(permitApplication!.vehicle!.registrationDocImgPath!)
          : null;
      carRegistrationController.text = carRegistrationImgUrl == null
          ? "File not found"
          : _getFileName(carRegistrationImgUrl!) ?? "File not found";
    }
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

  void openLinkInNewTab(Uri? url) async {
    if (url != null) {
      var result = await launchUrl(
        url,
        webOnlyWindowName: "_blank",
      );

      if (!result) {
        emit(const ErrorPermitApplications(
            snackBarMessage: "Browser prevented this action"));
      }
    } else {
      emit(const ErrorPermitApplications(
          snackBarMessage: "Could not find path to file"));
    }
  }

  Future<void> loadPermits() async {
    emit(LoadingPermitApplications());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data!.toList();
    }

    emit(const LoadedPermitApplications());
  }

  void setQueryParams({
    required PermitApplicationsParams updatedParams,
    int? sortColumnIndex,
    bool updateDatasource = true,
  }) {
    params = PermitApplicationsParams(
      pageSize: updatedParams.pageSize ?? params.pageSize,
      currentPage: updatedParams.currentPage ?? params.currentPage,
      studentId: updatedParams.studentId,
      name: updatedParams.name,
      status: updatedParams.status,
      academicYear: updatedParams.academicYear,
      permitId: updatedParams.permitId,
      orderBy: updatedParams.orderBy ?? params.orderBy,
      orderByDirection:
          updatedParams.orderByDirection ?? params.orderByDirection,
    );
    this.sortColumnIndex = sortColumnIndex ?? this.sortColumnIndex;
    updateDatasource ? applicationsDataSource.refreshDatasource() : null;
    emit(PermitApplicationsParamsUpdate(params: params));
  }

  Future<List<PermitApplicationInfoDto>> getPermitApplications(
      int startIndex, int count) async {
    emit(LoadingPermitApplications());
    try {
      var result = await _api.getPermitApplicationApi().permitApplicationGet(
            pageSize: count,
            pageNumber: startIndex ~/ count,
            status: params.status,
            studentId: params.studentId,
            name: params.name,
            year: params.academicYear,
            permitId: params.permitId,
            orderBy: params.orderBy,
            orderByDirection: params.orderByDirection,
          );

      if (result.data == null) {
        emit(ErrorPermitApplications(snackBarMessage: result.statusMessage));
        return [];
      }

      var pagination = jsonDecode(result.headers["pagination"]!.join(","));
      totalRows = pagination["totalItems"];
      applications = result.data!;
      emit(LoadedPermitApplications(applications: result.data));
      return result.data!;
    } catch (e) {
      emit(ErrorPermitApplications(snackBarMessage: e.toString()));
      return [];
    }
  }

  void onRowTap(int index) {
    emit(RowTappedState(id: applications[index].id!));
  }

  void selectPermitType(PermitDto permit) {
    selectedPermit = permit;
    selectedPermitController.text = selectedPermit!.name!;
    emit(PermitApplicationsUpdated(selectedPermit: selectedPermit));
  }

  void setSelectedPhoneCountry(Country? country) async {
    if (countries.isEmptyOrNull) {
      await loadCountries();
    }
    selectedPhoneCountry = country;
    emit(PermitApplicationsUpdated(selectedCountry: selectedPhoneCountry));
  }

  void setSelectedCarNationality(Country country) async {
    if (countries.isEmptyOrNull) {
      await loadCountries();
    }
    selectedCarNationality = country;
    selectedCarNationalityController.text = selectedCarNationality!.name;
    emit(PermitApplicationsUpdated(selectedCountry: selectedCarNationality));
  }

  void onChangedAttendingDay(List<String> items) {
    selectedAttendingDays = items;

    _attendingDays.updateAll((key, value) => false);

    for (String day in selectedAttendingDays) {
      _attendingDays[day] = true;
    }

    emit(PermitApplicationsUpdated(attendingDays: selectedAttendingDays));
  }

  Future<void> onPayment() async {
    emit(LoadingPermitApplications());
    try {
      var result =
          await _api.getPermitApplicationApi().permitApplicationPayIdPost(
                id: applicationId!,
              );

      if (result.data == null) {
        emit(ErrorPermitApplications(snackBarMessage: result.statusMessage));
        return;
      } else if (result.data!.responseCode == ResponseCode.Failed) {
        emit(ErrorPermitApplications(
            snackBarMessage: result.data!.message.toString()));
        return;
      }

      emit(LoadedPermitApplications(
          snackBarMessage: result.data!.message.toString()));
      applicationsDataSource.refreshDatasource();
    } catch (e) {
      emit(
        ErrorPermitApplications(snackBarMessage: e.toString()),
      );
    }
  }

  Future<void> onSubmit(bool accept) async {
    emit(LoadingPermitApplications());
    if (!formKey.currentState!.validate()) {
      emit(const ErrorPermitApplications(
          snackBarMessage: "Please fill in the required fields"));
      return;
    }

    try {
      var result =
          await _api.getPermitApplicationApi().permitApplicationResponseIdPost(
                id: applicationId!,
                permitApplicationDto: PermitApplicationDto(
                  status: accept
                      ? PermitApplicationStatus.AwaitingPayment
                      : PermitApplicationStatus.Denied,
                  academicYear: AcademicYear.values.toList()[academicYear ?? 0],
                  attendingDays: _attendingDays.values.toList(),
                  // licenseImgPath: drivingLicenseImgFile!.name,
                  permit: selectedPermit!,
                  phoneNumberCountry: selectedPhoneCountry!.isoCode,
                  phoneNumber: phoneNumberController.text,
                  siblingsCount: int.parse(numberOfCompanionsController.text),
                  vehicle: VehicleDto(
                    color: carColorController.text,
                    make: carMakeController.text,
                    model: carModelController.text,
                    nationality: selectedCarNationality!.isoCode,
                    plateNumber: plateNumberController.text,
                    // registrationDocImgPath: drivingLicenseImgFile!.name,
                    year: int.parse(carYearController.text),
                  ),
                ),
              );

      if (result.data == null) {
        emit(ErrorPermitApplications(snackBarMessage: result.statusMessage));
        return;
      } else if (result.data!.responseCode == ResponseCode.Failed) {
        emit(ErrorPermitApplications(
            snackBarMessage: result.data!.message.toString()));
        return;
      }

      emit(LoadedPermitApplications(
          snackBarMessage: result.data!.message.toString()));
      applicationsDataSource.refreshDatasource();
    } catch (e) {
      if (e is DioException && (e).response != null) {
        emit(
          ErrorPermitApplications(
            snackBarMessage:
                (ResponseDto.fromJson((e).response!.data)).toString(),
          ),
        );
      }
    }
  }

  void disableEditingHandler(String prevStr, TextEditingController controller) {
    controller.text = prevStr;
  }
}
