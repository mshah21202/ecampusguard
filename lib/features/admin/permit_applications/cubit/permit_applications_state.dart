part of 'permit_applications_cubit.dart';

class PermitApplicationsState extends Equatable {
  const PermitApplicationsState({
    this.applications,
    this.snackBarMessage,
    this.params,
    this.id,
    this.attendingDays,
    this.selectedCountry,
    this.uploadedFile,
    this.selectedPermit,
    this.acknowledged,
    this.selectedApplications,
  });

  final List<String>? attendingDays;
  final Country? selectedCountry;
  final PlatformFile? uploadedFile;
  final PermitDto? selectedPermit;
  final bool? acknowledged;
  final List<PermitApplicationInfoDto>? applications;
  final List<PermitApplicationInfoDto>? selectedApplications;
  final String? snackBarMessage;
  final PermitApplicationsParams? params;
  final int? id;

  @override
  List<Object?> get props => [
        applications,
        snackBarMessage,
        params,
        id,
        attendingDays,
        selectedCountry,
        uploadedFile,
        selectedPermit,
        acknowledged,
        selectedApplications,
      ];
}

class PermitApplicationsInitial extends PermitApplicationsState {}

class PermitApplicationsUpdated extends PermitApplicationsState {
  const PermitApplicationsUpdated({
    super.attendingDays,
    super.selectedCountry,
    super.selectedPermit,
    super.acknowledged,
  });
}

class PermitApplicationsRowSelection extends PermitApplicationsState {
  const PermitApplicationsRowSelection({super.selectedApplications});
}

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

class UploadedFile extends PermitApplicationsState {
  const UploadedFile({super.uploadedFile});
}
