part of 'user_permit_applications_cubit.dart';

class UserPermitApplicationsState extends Equatable {
  const UserPermitApplicationsState({
    this.snackbarMessage,
    this.applications,
    this.permits,
    this.params,
    this.permitApplication,
    this.id,
  });

  final String? snackbarMessage;
  final List<PermitApplicationInfoDto>? applications;
  final List<PermitDto>? permits;
  final PermitApplicationsParams? params;
  final PermitApplicationDto? permitApplication;
  final int? id;

  @override
  List<Object?> get props => [
        snackbarMessage,
        applications,
        permits,
        params,
        permitApplication,
        id,
      ];
}

class UserPermitApplicationsInitial extends UserPermitApplicationsState {}

class UserPermitApplicationsLoading extends UserPermitApplicationsState {}

class UserPermitApplicationsLoaded extends UserPermitApplicationsState {
  const UserPermitApplicationsLoaded({
    super.snackbarMessage,
    super.applications,
    super.permits,
    super.permitApplication,
  });
}

class UserPermitApplicationsError extends UserPermitApplicationsState {
  const UserPermitApplicationsError({super.snackbarMessage});
}

class UserPermitApplicationsParamsUpdated extends UserPermitApplicationsState {
  const UserPermitApplicationsParamsUpdated({super.params});
}

class RowTappedState extends UserPermitApplicationsState {
  const RowTappedState({required super.id});
}
