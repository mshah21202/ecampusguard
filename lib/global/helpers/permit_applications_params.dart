import 'dart:core';

import 'package:ecampusguardapi/ecampusguardapi.dart';

class PermitApplicationsParams {
  PermitApplicationsParams.empty(
      {this.pageSize,
      this.currentPage,
      this.studentId,
      this.name,
      this.academicYear,
      this.permitId,
      this.status,
      this.orderBy,
      this.orderByDirection});

  PermitApplicationsParams(
      {this.pageSize,
      this.currentPage,
      this.studentId,
      this.name,
      this.academicYear,
      this.permitId,
      this.status,
      this.orderBy,
      this.orderByDirection});

  PermitApplicationsParams copyWith({
    int? pageSize,
    bool pageSizeClear = false,
    int? currentPage,
    bool currentPageClear = false,
    String? studentId,
    bool studentIdClear = false,
    String? name,
    bool nameClear = false,
    AcademicYear? academicYear,
    bool academicYearClear = false,
    int? permitId,
    bool permitIdClear = false,
    PermitApplicationStatus? status,
    bool statusClear = false,
    PermitApplicationOrderBy? orderBy,
    bool orderByClear = false,
    String? orderByDirection,
    bool orderByDirectionClear = false,
  }) {
    return PermitApplicationsParams(
      pageSize: pageSize ?? this.pageSize,
      currentPage: currentPage ?? this.currentPage,
      studentId: studentIdClear ? null : studentId ?? this.studentId,
      name: nameClear ? null : name ?? this.name,
      academicYear:
          academicYearClear ? null : academicYear ?? this.academicYear,
      permitId: permitIdClear ? null : permitId ?? this.permitId,
      status: statusClear ? null : status ?? this.status,
      orderBy: orderBy ?? this.orderBy,
      orderByDirection: orderByDirection ?? this.orderByDirection,
    );
  }

  PermitApplicationsParams.fromUri(Uri uri)
      : status = uri.queryParameters["status"] != null
            ? PermitApplicationStatus
                .values[int.parse(uri.queryParameters["status"]!)]
            : null,
        pageSize = uri.queryParameters["pageSize"] != null
            ? int.parse(uri.queryParameters["pageSize"]!)
            : null,
        currentPage = uri.queryParameters["currentPage"] != null
            ? int.parse(uri.queryParameters["currentPage"]!)
            : null,
        studentId = uri.queryParameters["studentId"],
        name = uri.queryParameters["name"],
        academicYear = uri.queryParameters["academicYear"] != null
            ? AcademicYear
                .values[int.parse(uri.queryParameters["academicYear"]!)]
            : null,
        permitId = uri.queryParameters["permitId"] != null
            ? int.parse(uri.queryParameters["permitId"]!)
            : null,
        orderBy = uri.queryParameters["orderBy"] != null
            ? PermitApplicationOrderBy
                .values[int.parse(uri.queryParameters["orderBy"]!)]
            : null,
        orderByDirection = uri.queryParameters["orderByDirection"];

  final int? pageSize;
  final int? currentPage;
  final String? studentId;
  final String? name;
  final AcademicYear? academicYear;
  final int? permitId;
  final PermitApplicationStatus? status;
  final PermitApplicationOrderBy? orderBy;
  final String? orderByDirection;

  @override
  String toString() {
    String result = "";

    if (pageSize != null) {
      result = "$result${result.isNotEmpty ? "&" : "?"}pageSize=$pageSize";
    }

    if (currentPage != null) {
      result =
          "$result${result.isNotEmpty ? "&" : "?"}currentPage=$currentPage";
    }

    if (studentId != null && studentId!.isNotEmpty) {
      result = "$result${result.isNotEmpty ? "&" : "?"}studentId=$studentId";
    }

    if (name != null && name!.isNotEmpty) {
      result = "$result${result.isNotEmpty ? "&" : "?"}name=$name";
    }

    if (academicYear != null) {
      result =
          "$result${result.isNotEmpty ? "&" : "?"}academicYear=${academicYear!.index}";
    }

    if (permitId != null) {
      result = "$result${result.isNotEmpty ? "&" : "?"}permitId=$permitId";
    }

    if (status != null) {
      result = "$result${result.isNotEmpty ? "&" : "?"}status=${status!.index}";
    }

    if (orderBy != null) {
      result =
          "$result${result.isNotEmpty ? "&" : "?"}orderBy=${orderBy!.index}";
    }

    if (orderByDirection != null && orderByDirection != null) {
      result =
          "$result${result.isNotEmpty ? "&" : "?"}orderByDirection=$orderByDirection";
    }

    return result;
  }
}
