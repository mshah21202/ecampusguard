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
    loadUpdateRequests();
  }

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
  UpdateRequestDto? UpdateRequest;
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

  Future<void> loadUpdateRequests() async {
    emit(UpdateRequestLoading());

    var result = await _api.getUserPermitApi().userPermitUpdateRequestsGet();
    if (result.data != null) {
      requests = result.data!.toList();
    }
    emit(UpdateRequestLoading());
  }

  Future<List<UpdateRequestDto>> getUpdateRequests(
      int startIndex, int count) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitUpdateRequestsGet(
            id: null,
            permitId: params.userPermitId,
            status: params.status,
            pageNumber: startIndex ~/ count + 1,
            pageSize: count,
          );
      if (result.data == null) {
        emit(const UpdateRequestError("Failed to fetch update requests"));
        return [];
      }
      var pagination = jsonDecode(result.headers["pagination"]!.join(","));
      totalRows = pagination["totalItems"];
      requests = result.data!;
      emit(UpdateRequestLoaded(requests));
      return result.data!;
    } catch (e) {
      emit(UpdateRequestError(
          "Failed to fetch update requests: ${e.toString()}"));
      return [];
    }
  }

  Future<void> loadRequestDetails() async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api
          .getUserPermitApi()
          .userPermitUpdateRequestsIdGet(id: requestId!);
      if (result.data != null) {
        UpdateRequest = result.data!;
        emit(UpdateRequestLoaded([UpdateRequest!]));
      } else {
        emit(const UpdateRequestError("Failed to load request details"));
      }
    } catch (e) {
      emit(UpdateRequestError(
          "Failed to load request details: ${e.toString()}"));
    }
  }



  void acceptRequest(int requestId) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api
          .getUserPermitApi()
          .userPermitUpdateRequestsIdResponsePost(id: requestId, accept: true);
      if (result.data?.responseCode == ResponseCode.Success) {
        emit(UpdateRequestAccepted("Request accepted successfully.",
            result.data!.message ?? "Request has been accepted."));
        loadUpdateRequests(); // Refresh the list after updating
      } else {
        emit(UpdateRequestError(
            "Failed to accept request: ${result.data?.message ?? 'Unknown error'}"));
      }
    } catch (e) {
      emit(UpdateRequestError("Failed to accept request: ${e.toString()}"));
    }
  }

  void rejectRequest(int requestId) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api
          .getUserPermitApi()
          .userPermitUpdateRequestsIdResponsePost(id: requestId, accept: false);
      if (result.data?.responseCode == ResponseCode.Success) {
        emit(UpdateRequestRejected("Request rejected successfully.",
            result.data!.message ?? "Request has been rejected."));
        loadUpdateRequests(); // Refresh the list after updating
      } else {
        emit(UpdateRequestError(
            "Failed to reject request: ${result.data?.message ?? 'Unknown error'}"));
      }
    } catch (e) {
      emit(UpdateRequestError("Failed to reject request: ${e.toString()}"));
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
        emit(const UpdateRequestError("Browser prevented this action"));
      }
    } else {
      emit(const UpdateRequestError("Could not find path to file"));
    }
  }
}
