part of 'permit_applications_cubit.dart';

class PermitApplicationsState extends Equatable {
  const PermitApplicationsState({
    this.applications,
    this.snackBarMessage,
    this.params,
    this.id,
  });

  final List<PermitApplicationInfoDto>? applications;
  final String? snackBarMessage;
  final PermitApplicationsParams? params;
  final int? id;

  @override
  List<Object> get props => [
        applications ?? [],
        snackBarMessage ?? "",
        params ?? PermitApplicationsParams.empty(),
        id ?? 0,
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

class RowTappedState extends PermitApplicationsState {
  const RowTappedState({required super.id});
}

class PermitApplicationsParamsUpdate extends PermitApplicationsState {
  const PermitApplicationsParamsUpdate({required super.params});
}
