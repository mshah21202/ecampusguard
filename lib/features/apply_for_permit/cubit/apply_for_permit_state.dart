part of 'apply_for_permit_cubit.dart';

class ApplyForPermitState extends Equatable {
  const ApplyForPermitState(
      {this.attendingDays,
      this.selectedCountry,
      this.uploadedFile,
      this.selectedPermit,
      this.acknowledged});

  final List<bool>? attendingDays;
  final Country? selectedCountry;
  final PlatformFile? uploadedFile;
  final PermitDto? selectedPermit;
  final bool? acknowledged;

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

class LoadedApplyForPermitState extends ApplyForPermitState {}

class UploadedFile extends ApplyForPermitState {
  UploadedFile({super.uploadedFile});
}
