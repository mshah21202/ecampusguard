part of 'apply_for_permit_cubit.dart';

class ApplyForPermitState extends Equatable {
  const ApplyForPermitState(
      {this.attendingDays,
      this.selectedCountry,
      this.uploadedFile,
      this.selectedPermit,
      this.acknowledged,
      this.snackBarMessage});

  final List<String>? attendingDays;
  final Country? selectedCountry;
  final PlatformFile? uploadedFile;
  final PermitDto? selectedPermit;
  final bool? acknowledged;
  final String? snackBarMessage;

  @override
  List<Object> get props => [
        attendingDays ?? [false, false, false, false, false],
        selectedCountry ??
            Country(
              name: "",
              isoCode: "",
              phoneCode: "",
              flag: "",
              currency: "",
              latitude: "",
              longitude: "",
            )
      ];
}

class ApplyForPermitInitial extends ApplyForPermitState {}

class ApplyForPermitUpdated extends ApplyForPermitState {
  const ApplyForPermitUpdated({
    super.attendingDays,
    super.selectedCountry,
    super.selectedPermit,
    super.acknowledged,
  });
}

class LoadingApplyForPermitState extends ApplyForPermitState {}

class LoadedApplyForPermitState extends ApplyForPermitState {
  const LoadedApplyForPermitState({super.snackBarMessage});
}

class FailedApplyForPermitState extends ApplyForPermitState {
  const FailedApplyForPermitState({super.snackBarMessage});
}

class UploadedFile extends ApplyForPermitState {
  const UploadedFile({super.uploadedFile});
}
