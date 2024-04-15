part of 'permit_applications_cubit.dart';

class PermitApplicationsState extends Equatable {
  const PermitApplicationsState({
    this.applications,
    this.snackBarMessage,
    this.pageSize,
    this.currentPage,
    this.studentId,
    this.name,
    this.academicYear,
    this.permitId,
    this.status,
    this.orderBy,
    this.orderByDirection,
  });

  final List<PermitApplicationInfoDto>? applications;
  final String? snackBarMessage;
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
  List<Object> get props => [
        applications ?? [],
        snackBarMessage ?? "",
        pageSize ?? 10,
        currentPage ?? 0,
        studentId ?? "",
        name ?? "",
        academicYear ?? AcademicYear.unknownDefaultOpenApi,
        permitId ?? 0,
        status ?? PermitApplicationStatus.unknownDefaultOpenApi,
        orderBy ?? PermitApplicationOrderBy.unknownDefaultOpenApi,
        orderByDirection ?? "ASC",
      ];
}

class PermitApplicationsInitial extends PermitApplicationsState {}

class LoadedPermitApplications extends PermitApplicationsState {
  const LoadedPermitApplications({super.applications, super.snackBarMessage});
}

class LoadingPermitApplications extends PermitApplicationsState {}

class ErrorPermitApplications extends PermitApplicationsState {
  const ErrorPermitApplications({super.snackBarMessage});
}

class SetQueryParamsPermitApplications extends PermitApplicationsState {
  const SetQueryParamsPermitApplications({
    super.pageSize,
    super.currentPage,
    super.studentId,
    super.name,
    super.academicYear,
    super.permitId,
    super.status,
    super.orderBy,
    super.orderByDirection,
  });
}
