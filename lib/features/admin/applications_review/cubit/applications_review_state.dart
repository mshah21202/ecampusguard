part of 'applications_review_cubit.dart';

class ApplicationsReviewState extends Equatable {
  const ApplicationsReviewState(
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

class ApplicationsReviewInitial extends ApplicationsReviewState {}

class ApplicationsReviewUpdated extends ApplicationsReviewState {
  const ApplicationsReviewUpdated({
    super.attendingDays,
    super.selectedCountry,
    super.selectedPermit,
    super.acknowledged,
  });
}

class LoadingApplicationsReviewState extends ApplicationsReviewState {}

class LoadedApplicationsReviewState extends ApplicationsReviewState {
  const LoadedApplicationsReviewState({super.snackBarMessage});
}

class FailedApplicationsReviewState extends ApplicationsReviewState {
  const FailedApplicationsReviewState({super.snackBarMessage});
}

class UploadedFile extends ApplicationsReviewState {
  const UploadedFile({super.uploadedFile});
}
