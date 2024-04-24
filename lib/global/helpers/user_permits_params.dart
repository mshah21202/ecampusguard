import 'dart:core';

import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';

class UserPermitsParams extends Equatable {
  const UserPermitsParams.empty(
      {this.pageSize,
      this.plateNumber,
      this.currentPage,
      this.studentId,
      this.status,
      this.orderBy,
      this.permitId,
      this.orderByDirection});

  const UserPermitsParams(
      {required this.pageSize,
      required this.currentPage,
      required this.plateNumber,
      required this.studentId,
      required this.permitId,
      required this.status,
      required this.orderBy,
      required this.orderByDirection});

  UserPermitsParams.fromUri(Uri uri)
      : status = uri.queryParameters["status"] != null
            ? UserPermitStatus.values[int.parse(uri.queryParameters["status"]!)]
            : null,
        pageSize = uri.queryParameters["pageSize"] != null
            ? int.parse(uri.queryParameters["pageSize"]!)
            : null,
        permitId = uri.queryParameters["permitId"] != null
            ? int.parse(uri.queryParameters["permitId"]!)
            : null,
        plateNumber = uri.queryParameters["plateNumber"],
        currentPage = uri.queryParameters["currentPage"] != null
            ? int.parse(uri.queryParameters["currentPage"]!)
            : null,
        studentId = uri.queryParameters["studentId"],
        orderBy = uri.queryParameters["orderBy"] != null
            ? UserPermitOrderBy
                .values[int.parse(uri.queryParameters["orderBy"]!)]
            : null,
        orderByDirection = uri.queryParameters["orderByDirection"];

  final String? studentId;
  final String? plateNumber;
  final UserPermitStatus? status;
  final UserPermitOrderBy? orderBy;
  final String? orderByDirection;
  final int? permitId;
  final int? currentPage;
  final int? pageSize;

  @override
  String toString() {
    String result = "";

    if (pageSize != null) {
      result = "$result${result.isNotEmpty ? "&" : ""}pageSize=$pageSize";
    }

    if (currentPage != null) {
      result = "$result${result.isNotEmpty ? "&" : ""}currentPage=$currentPage";
    }

    if (studentId != null && studentId!.isNotEmpty) {
      result = "$result${result.isNotEmpty ? "&" : ""}studentId=$studentId";
    }

    if (plateNumber != null && plateNumber!.isNotEmpty) {
      result = "$result${result.isNotEmpty ? "&" : ""}plateNumber=$plateNumber";
    }

    if (permitId != null) {
      result = "$result${result.isNotEmpty ? "&" : ""}permitId=$permitId";
    }

    if (status != null) {
      result = "$result${result.isNotEmpty ? "&" : ""}status=${status!.index}";
    }

    if (orderBy != null) {
      result =
          "$result${result.isNotEmpty ? "&" : ""}orderBy=${orderBy!.index}";
    }

    if (orderByDirection != null && orderByDirection != null) {
      result =
          "$result${result.isNotEmpty ? "&" : ""}orderByDirection=$orderByDirection";
    }

    return result;
  }

  @override
  List<Object?> get props => [
        studentId,
        plateNumber,
        status,
        orderBy,
        orderByDirection,
        currentPage,
        pageSize,
      ];
}
