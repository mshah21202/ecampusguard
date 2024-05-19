import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/personal_information_details.dart';
import 'package:ecampusguard/features/user_permit_details/view/widgets/vehicle_infromation_details.dart';
import 'package:ecampusguard/global/helpers/user_permits_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'user_permits_state.dart';

class UserPermitsCubit extends Cubit<UserPermitsState> {
  UserPermitsCubit({required this.params}) : super(UserPermitsInitial()) {
    userPermitsDataSource = UserPermitsDataSource.fromApi(
      fetchFunction: getUserPermits,
      cubit: this,
    );

    loadPermits();
    loadCountries();
  }

  final GlobalKey<PersonalInformationDetailsState> personalInfoKey =
      GlobalKey<PersonalInformationDetailsState>();
  final GlobalKey<VehicleInformationDetailsState> vehicleInfoKey =
      GlobalKey<VehicleInformationDetailsState>();
  late UserPermitsDataSource userPermitsDataSource;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  UserPermitsParams params;
  List<UserPermitDto> userPermits = [];
  List<PermitDto> permits = [];
  List<Country> countries = [];
  UserPermitDto? userPermit;
  int? userPermitId;
  PermitDto? newPermit;

  void onPermitChanged(int id) {
    newPermit = permits.firstWhere((permit) => permit.id == id);
    emit(UserPermitsLoaded(newPermit: newPermit));
  }

  void loadCountries() async {
    countries = await getAllCountries();
  }

  void loadPermits() async {
    emit(UserPermitsLoading());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data!.toList();
    }

    emit(UserPermitsLoaded(permits: permits));
  }

  void setQueryParams({
    required UserPermitsParams params,
    bool updateDatasource = true,
  }) {
    this.params = UserPermitsParams(
      pageSize: params.pageSize ?? this.params.pageSize ?? 10,
      currentPage: params.currentPage ?? this.params.currentPage ?? 0,
      plateNumber: params.plateNumber,
      studentId: params.studentId,
      status: params.status,
      permitId: params.permitId,
      orderBy: params.orderBy,
      orderByDirection: params.orderByDirection,
    );
    updateDatasource ? userPermitsDataSource.refreshDatasource() : null;

    emit(UserPermitsParamsUpdate(params: this.params));
  }

  void onPageChanged(int? page) {
    params = UserPermitsParams(
      pageSize: params.pageSize,
      currentPage: page,
      plateNumber: params.plateNumber,
      studentId: params.studentId,
      status: params.status,
      permitId: params.permitId,
      orderBy: params.orderBy,
      orderByDirection: params.orderByDirection,
    );
    setQueryParams(params: params);
  }

  void onRowTap(int index) {
    userPermitId = userPermits[index].id!;
    emit(UserPermitsOnRowTap(id: userPermitId!));
  }

  void getUserPermit() async {
    emit(UserPermitsLoading());
    try {
      if (userPermitId != null) {
        var result =
            await _api.getUserPermitApi().userPermitIdGet(id: userPermitId!);

        if (result.data == null) {
          emit(UserPermitsError(snackbarMessage: result.statusMessage));
          return;
        }

        userPermit = result.data;
        emit(UserPermitsLoaded(userPermit: userPermit));
        return;
      } else {
        emit(const UserPermitsError(
            snackbarMessage: "Could not load user permit."));
        return;
      }
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
      return;
    }
  }

  Future<List<UserPermitDto>> getUserPermits(int startIndex, int count) async {
    emit(UserPermitsLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitGet(
            pageNumber: params.currentPage ?? 0,
            pageSize: params.pageSize ?? 10,
            plateNumber: params.plateNumber,
            studentId: params.studentId,
            permitId: params.permitId,
            status: params.status,
            orderBy: params.orderBy,
            orderByDirection: params.orderByDirection,
          );

      if (result.data == null) {
        emit(UserPermitsError(snackbarMessage: result.statusMessage));
        return [];
      }

      userPermits = result.data!;
      emit(UserPermitsLoaded(userPermits: userPermits));
      return userPermits;
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
      return [];
    }
  }

  Future<void> onSubmit() async {
    emit(UserPermitsLoading());
    try {
      if (userPermitId != null) {
        var result = await _api.getUserPermitApi().userPermitIdPost(
              id: userPermitId!,
              updateUserPermitDto: UpdateUserPermitDto(
                permitId: newPermit?.id,
                phoneNumber:
                    personalInfoKey.currentState!.phoneNumberController.text,
                phoneNumberCountry:
                    personalInfoKey.currentState!.selectedPhoneCountry!.isoCode,
                licenseImgPath:
                    personalInfoKey.currentState!.drivingLicenseImgUrl,
                vehicle: VehicleDto(
                  plateNumber:
                      vehicleInfoKey.currentState!.plateNumberController.text,
                  nationality: vehicleInfoKey
                      .currentState!.selectedCarNationality!.isoCode,
                  make: vehicleInfoKey.currentState!.carMakeController.text,
                  model: vehicleInfoKey.currentState!.carModelController.text,
                  year: int.parse(
                      vehicleInfoKey.currentState!.carYearController.text),
                  color: vehicleInfoKey.currentState!.carColorController.text,
                  registrationDocImgPath:
                      vehicleInfoKey.currentState!.carRegistrationImgUrl,
                ),
              ),
              validateStatus: (status) => status != 500,
            );

        if (result.data == null) {
          emit(UserPermitsError(snackbarMessage: result.statusMessage));
          return;
        }

        if (result.data!.responseCode == ResponseCode.Failed) {
          emit(UserPermitsError(
              snackbarMessage: result.data!.message.toString()));
          return;
        }

        emit(UserPermitsLoaded(
            snackbarMessage: result.data!.message.toString()));
        userPermitsDataSource.refreshDatasource();
        return;
      }
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
    }
  }

  Future<void> onWithdraw() async {
    emit(UserPermitsLoading());
    try {
      if (userPermitId != null) {
        var result = await _api
            .getUserPermitApi()
            .userPermitWithdrawIdPost(id: userPermitId!);

        if (result.data == null) {
          emit(UserPermitsError(snackbarMessage: result.statusMessage));
          return;
        }

        if (result.data!.responseCode == ResponseCode.Failed) {
          emit(UserPermitsError(
              snackbarMessage: result.data!.message.toString()));
          return;
        }

        emit(UserPermitsLoaded(
            snackbarMessage: result.data!.message.toString()));
        userPermitsDataSource.refreshDatasource();
        return;
      }
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
      return;
    }
  }

  void onSendNotification({required String title, required String body}) async {
    emit(UserPermitsLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitNotificationIdPost(
          id: userPermitId!,
          notificationDto: NotificationDto(title: title, body: body));

      if (result.data == null) {
        emit(UserPermitsError(snackbarMessage: result.statusMessage));
        return;
      }

      emit(
          UserPermitsLoaded(snackbarMessage: result.data?.message?.toString()));
      return;
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
      return;
    }
  }
}
