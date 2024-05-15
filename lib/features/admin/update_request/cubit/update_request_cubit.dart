import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:country_state_city/models/country.dart';
import 'package:country_state_city/utils/country_utils.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/helpers/update_requests_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

part 'update_request_state.dart';

class UpdateRequestCubit extends Cubit<UpdateRequestState> {
  UpdateRequestCubit({required this.params})
      : super(UpdateRequestInitial()) {
    dataSource = UpdateRequestDataSource.fromApi(
      fetchFunction: fetchUpdateRequests,
      cubit: this,
    );
    loadUpdateRequests();
  }

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController phoneNumberCountryController = TextEditingController();
  final TextEditingController drivingLicenseController = TextEditingController();
  final TextEditingController userPermitController = TextEditingController();
  final TextEditingController updatedVehicleController = TextEditingController();

  List<UpdateRequestDto> requests = [];
  List<UpdateRequestDto> selectedRequests = [];
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  late UpdateRequestDataSource dataSource;
  UpdateRequestParams params;
  int? sortColumnIndex;
  int totalRows = 0;
  PaginatorController controller = PaginatorController();

  void selectedRowsListener() {
    selectedRequests = dataSource.selectionState == SelectionState.include
        ? dataSource.selectionRowKeys
            .map((key) => requests[(key as ValueKey<int>).value])
            .toList()
        : requests.indexed
            .where((element) => !dataSource.selectionRowKeys
                .contains(ValueKey(element.$1)))
            .map((e) => e.$2)
            .toList();

    if (dataSource.selectionState == SelectionState.none) {
      selectedRequests = [];
    }

    emit(UpdateRequestRowSelection(selectedRequests: selectedRequests));
  }

  Future<void> loadUpdateRequests() async {
    emit(UpdateRequestLoading());
    try {
      var result = await fetchUpdateRequests(0, params.pageSize ?? 10);
      if (result.isEmpty) {
        emit(UpdateRequestEmpty());
      } else {
        emit(UpdateRequestLoaded(result));
      }
    } catch (error) {
      emit(UpdateRequestError("Failed to load update requests: ${error.toString()}"));
    }
  }

  Future<List<UpdateRequestDto>> fetchUpdateRequests(int startIndex, int count) async {
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
        emit(UpdateRequestError("Failed to fetch update requests"));
        return [];
      }
      var pagination = jsonDecode(result.headers["pagination"]!.join(","));
      totalRows = pagination["totalItems"];
      requests = result.data!;
      emit(UpdateRequestLoaded(requests));
      return result.data!;
    } catch (e) {
      emit(UpdateRequestError("Failed to fetch update requests: ${e.toString()}"));
      return [];
    }
  }

  void acceptRequest(int requestId) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitUpdateRequestsIdResponsePost(id: requestId, accept: true);
      if (result.data?.responseCode == ResponseCode.Success) {
        emit(UpdateRequestAccepted("Request accepted successfully.", result.data!.message ?? "Request has been accepted."));
        loadUpdateRequests(); // Refresh the list after updating
      } else {
        emit(UpdateRequestError("Failed to accept request: ${result.data?.message ?? 'Unknown error'}"));
      }
    } catch (e) {
      emit(UpdateRequestError("Failed to accept request: ${e.toString()}"));
    }
  }

  void rejectRequest(int requestId) async {
    emit(UpdateRequestLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitUpdateRequestsIdResponsePost(id: requestId, accept: false);
      if (result.data?.responseCode == ResponseCode.Success) {
        emit(UpdateRequestRejected("Request rejected successfully.", result.data!.message ?? "Request has been rejected."));
        loadUpdateRequests(); // Refresh the list after updating
      } else {
        emit(UpdateRequestError("Failed to reject request: ${result.data?.message ?? 'Unknown error'}"));
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
      phoneNumberCountry: updatedParams.phoneNumberCountry ?? params.phoneNumberCountry,
      drivingLicenseImgPath: updatedParams.drivingLicenseImgPath ?? params.drivingLicenseImgPath,
      userPermitId: updatedParams.userPermitId ?? params.userPermitId,
      updatedVehicleId: updatedParams.updatedVehicleId ?? params.updatedVehicleId,
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

  String? _getFileName(Uri uri) {
    var regex = RegExp(r'([^\/?%]*\.(?:jpg|jpeg|png|gif|pdf))');

    for (String segment in uri.pathSegments) {
      if (regex.hasMatch(segment)) {
        return segment;
      }
    }

    return null;
  }

  // void openLinkInNewTab(Uri? url) async {
  //   if (url != null) {
  //     var result = await launchUrl(
  //       url,
  //       webOnlyWindowName: "_blank",
  //     );

  //     if (!result) {
  //       emit(UpdateRequestError("Browser prevented this action"));
  //     }
  //   } else {
  //     emit(UpdateRequestError("Could not find path to file"));
  //   }
  // }
}
