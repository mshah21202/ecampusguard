import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/helpers/update_requests_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

part 'update_request_state.dart';

class UpdateRequestCubit extends Cubit<UpdateRequestState> {
  UpdateRequestCubit({required this.params}) : super(UpdateRequestInitial()) {
    dataSource = UpdateRequestDataSource.fromApi(
      fetchFunction: getUpdateRequests,
      cubit: this,
    );
  }
  PermitApplicationDto? permitApplication;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneNumberCountryController =
      TextEditingController();
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController userPermitController = TextEditingController();
  final TextEditingController updatedVehicleController =
      TextEditingController();

  List<UpdateRequestDto> requests = [];
  List<UpdateRequestDto> selectedRequests = [];
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  late UpdateRequestDataSource dataSource;
  UpdateRequestParams params;
  int? sortColumnIndex;
  int totalRows = 0;
  PaginatorController controller = PaginatorController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UpdateRequestDto? updaterequest;
  int? requestId;

  void selectedRowsListener() {
    selectedRequests = dataSource.selectionState == SelectionState.include
        ? dataSource.selectionRowKeys
            .map((key) => requests[(key as ValueKey<int>).value])
            .toList()
        : requests.indexed
            .where((element) =>
                !dataSource.selectionRowKeys.contains(ValueKey(element.$1)))
            .map((e) => e.$2)
            .toList();

    if (dataSource.selectionState == SelectionState.none) {
      selectedRequests = [];
    }

    emit(UpdateRequestRowSelection(selectedRequests: selectedRequests));
  }

  Future<List<UpdateRequestDto>> getUpdateRequests(
      int startIndex, int count) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitUpdateRequestsGet(
            id: null,
            permitId: params.userPermitId,
            status: params.status,
            pageNumber: startIndex ~/ count,
            pageSize: count,
          );
      if (result.data == null) {
        emit(UpdateRequestError(snackBarMessage: result.statusMessage));
        return [];
      }
      var pagination = jsonDecode(result.headers["pagination"]!.join(","));
      totalRows = pagination["totalItems"];
      requests = result.data!;
      emit(UpdateRequestLoaded(requests: result.data));
      return result.data!;
    } catch (e) {
      emit(UpdateRequestError(snackBarMessage: e.toString()));
      return [];
    }
  }

  void loadRequestDetails() async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api
          .getUserPermitApi()
          .userPermitUpdateRequestsIdGet(id: requestId!);
      if (result.data != null) {
        updaterequest = result.data!;
        emit(const UpdateRequestLoaded());
      }
    } catch (e) {
      emit(UpdateRequestError(
          snackBarMessage: "Failed to load request details: ${e.toString()}"));
    }
  }

  Future<void> onSubmitResponse(int requestId, bool accept) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api
          .getUserPermitApi()
          .userPermitUpdateRequestsIdResponsePost(
              id: requestId, accept: accept);
      if (result.data?.responseCode == ResponseCode.Success) {
        emit(UpdateRequestLoaded(
          snackBarMessage: result.data!.message.toString(),
        ));
      } else {
        emit(UpdateRequestError(
          snackBarMessage:
              "Failed to accept request: ${result.data?.message ?? 'Unknown error'}",
        ));
      }
      dataSource.refreshDatasource();
    } catch (e) {
      emit(
        UpdateRequestError(
            snackBarMessage: "Failed to accept request: ${e.toString()}"),
      );
    }
  }

  void setQueryParams({
    required UpdateRequestParams updatedParams,
    int? sortColumnIndex,
    bool updateDatasource = true,
  }) {
    params = UpdateRequestParams(
      id: updatedParams.id ?? params.id,
      status: updatedParams.status ?? params.status,
      phoneNumber: updatedParams.phoneNumber ?? params.phoneNumber,
      phoneNumberCountry:
          updatedParams.phoneNumberCountry ?? params.phoneNumberCountry,
      drivingLicenseImgPath:
          updatedParams.drivingLicenseImgPath ?? params.drivingLicenseImgPath,
      userPermitId: updatedParams.userPermitId ?? params.userPermitId,
      updatedVehicleId:
          updatedParams.updatedVehicleId ?? params.updatedVehicleId,
    );
    this.sortColumnIndex = sortColumnIndex ?? this.sortColumnIndex;
    if (updateDatasource) {
      dataSource.refreshDatasource();
    }
    emit(UpdateRequestParamsUpdate(params: params));
  }

  void onRowTap(int index) {
    emit(RowTappedState(id: requests[index].id!));
  }

  void openLinkInNewTab(Uri? url) async {
    if (url != null) {
      var result = await launchUrl(
        url,
        webOnlyWindowName: "_blank",
      );

      if (!result) {
        emit(const UpdateRequestError(
            snackBarMessage: "Browser prevented this action"));
      }
    } else {
      emit(const UpdateRequestError(
          snackBarMessage: "Could not find path to file"));
    }
  }
}
