import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'user_permit_applications_state.dart';

class UserPermitApplicationsCubit extends Cubit<UserPermitApplicationsState> {
  UserPermitApplicationsCubit({
    PermitApplicationsParams? params,
  })  : params = params ?? PermitApplicationsParams.empty(),
        super(UserPermitApplicationsInitial()) {
    applicationsDataSource = UserPermitApplicationsDataSource.fromApi(
      fetchFunction: getPermitApplications,
      cubit: this,
    );

    loadPermits();
    loadCountries();
  }

  late UserPermitApplicationsDataSource applicationsDataSource;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  PermitApplicationsParams params;
  List<PermitApplicationInfoDto> applications = [];
  List<PermitDto> permits = [];
  List<Country> countries = [];
  Country? selectedPhoneCountry;
  PermitApplicationDto? permitApplication;
  int totalRows = 0;
  int? sortColumnIndex;
  int? applicationId;

  void loadCountries() async {
    countries = await getAllCountries();
  }

  void getApplicationDetails() async {
    emit(UserPermitApplicationsLoading());
    try {
      var result = await _api
          .getPermitApplicationApi()
          .permitApplicationIdGet(id: applicationId!);
      if (result.data == null) {
        emit(
            UserPermitApplicationsError(snackbarMessage: result.statusMessage));
        return;
      }

      permitApplication = result.data!;
      selectedPhoneCountry = countries.firstWhere(
          (c) => c.isoCode == permitApplication!.phoneNumberCountry!);
      emit(UserPermitApplicationsLoaded(permitApplication: permitApplication));
    } catch (e) {
      emit(UserPermitApplicationsError(snackbarMessage: e.toString()));
    }
  }

  void setQueryParams({
    required PermitApplicationsParams updatedParams,
    int? sortColumnIndex,
    bool updateDatasource = true,
  }) {
    params = updatedParams;
    this.sortColumnIndex = sortColumnIndex ?? this.sortColumnIndex;
    updateDatasource ? applicationsDataSource.refreshDatasource() : null;
    emit(UserPermitApplicationsParamsUpdated(params: params));
  }

  Future<void> loadPermits() async {
    emit(UserPermitApplicationsLoading());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data!.toList();
    }

    emit(UserPermitApplicationsLoaded(permits: permits));
  }

  Future<List<PermitApplicationInfoDto>> getPermitApplications(
      int startIndex, int count) async {
    emit(UserPermitApplicationsLoading());
    try {
      var result = await _api.getPermitApplicationApi().permitApplicationGet(
            year: params.academicYear,
            permitId: params.permitId,
            status: params.status,
            orderBy: params.orderBy,
            orderByDirection: params.orderByDirection,
            pageSize: count,
            pageNumber: startIndex ~/ count,
          );

      if (result.data == null) {
        emit(
            UserPermitApplicationsError(snackbarMessage: result.statusMessage));
        return [];
      }

      var pagination = jsonDecode(result.headers["pagination"]!.join(","));
      totalRows = pagination["totalItems"];
      applications = result.data!;
      emit(UserPermitApplicationsLoaded(applications: applications));
    } catch (e) {
      emit(UserPermitApplicationsError(snackbarMessage: e.toString()));
      return [];
    }
    return applications;
  }

  void onRowTap(int index) {
    emit(RowTappedState(id: applications[index].id!));
    emit(UserPermitApplicationsLoaded(applications: applications));
  }
}
