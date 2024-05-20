import 'dart:core';
import 'package:ecampusguardapi/ecampusguardapi.dart';

class UpdateRequestParams {
  final int? id;
  final UpdateRequestStatus? status;
  final String? phoneNumber;
  final String? phoneNumberCountry;
  final String? drivingLicenseImgPath;
  final int? userPermitId;
  final int? updatedVehicleId;
  final int? pageSize;
  final int? currentPage;

  UpdateRequestParams({
    this.id,
    this.status,
    this.phoneNumber,
    this.phoneNumberCountry,
    this.drivingLicenseImgPath,
    this.userPermitId,
    this.updatedVehicleId,
    this.pageSize,
    this.currentPage,
  });

  UpdateRequestParams.empty()
      : id = null,
        status = null,
        phoneNumber = null,
        phoneNumberCountry = null,
        drivingLicenseImgPath = null,
        userPermitId = null,
        updatedVehicleId = null,
        pageSize = null,
        currentPage = null;

  UpdateRequestParams.fromUri(Uri uri)
      : id = uri.queryParameters['id'] != null ? int.parse(uri.queryParameters['id']!) : null,
        status = uri.queryParameters['status'] != null ? UpdateRequestStatus.values[int.parse(uri.queryParameters['status']!)] : null,
        phoneNumber = uri.queryParameters['phoneNumber'],
        phoneNumberCountry = uri.queryParameters['phoneNumberCountry'],
        drivingLicenseImgPath = uri.queryParameters['drivingLicenseImgPath'],
        userPermitId = uri.queryParameters['userPermitId'] != null ? int.parse(uri.queryParameters['userPermitId']!) : null,
        updatedVehicleId = uri.queryParameters['updatedVehicleId'] != null ? int.parse(uri.queryParameters['updatedVehicleId']!) : null,
        pageSize = uri.queryParameters['pageSize'] != null ? int.parse(uri.queryParameters['pageSize']!) : null,
        currentPage = uri.queryParameters['currentPage'] != null ? int.parse(uri.queryParameters['currentPage']!) : null;

  UpdateRequestParams copyWith({
    int? id,
    UpdateRequestStatus? status,
    String? phoneNumber,
    String? phoneNumberCountry,
    String? drivingLicenseImgPath,
    int? userPermitId,
    int? updatedVehicleId,
    int? pageSize,
    int? currentPage, required String orderBy,
  }) {
    return UpdateRequestParams(
      id: id ?? this.id,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberCountry: phoneNumberCountry ?? this.phoneNumberCountry,
      drivingLicenseImgPath: drivingLicenseImgPath ?? this.drivingLicenseImgPath,
      userPermitId: userPermitId ?? this.userPermitId,
      updatedVehicleId: updatedVehicleId ?? this.updatedVehicleId,
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  String toString() {
    var params = <String, String>{};
    if (id != null) params['id'] = id.toString();
    if (status != null) params['status'] = status!.index.toString();
    if (phoneNumber != null && phoneNumber!.isNotEmpty) params['phoneNumber'] = phoneNumber!;
    if (phoneNumberCountry != null && phoneNumberCountry!.isNotEmpty) params['phoneNumberCountry'] = phoneNumberCountry!;
    if (drivingLicenseImgPath != null && drivingLicenseImgPath!.isNotEmpty) params['drivingLicenseImgPath'] = drivingLicenseImgPath!;
    if (userPermitId != null) params['userPermitId'] = userPermitId.toString();
    if (updatedVehicleId != null) params['updatedVehicleId'] = updatedVehicleId.toString();
    if (pageSize != null) params['pageSize'] = pageSize.toString();
    if (currentPage != null) params['currentPage'] = currentPage.toString();
    return params.entries.map((e) => '${e.key}=${e.value}').join('&');
  }
}
