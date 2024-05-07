part of 'user_permit_details_cubit.dart';

class UserPermitDetailsState extends Equatable {
  const UserPermitDetailsState({
    this.userPermit,
    this.snackbarMessage,
    this.selectedPhoneCountry,
    this.selectedCarNationality,
    this.drivingLicenseFile,
    this.carRegistrationFile,
  });

  final UserPermitDto? userPermit;
  final String? snackbarMessage;
  final Country? selectedPhoneCountry;
  final Country? selectedCarNationality;
  final PlatformFile? drivingLicenseFile;
  final PlatformFile? carRegistrationFile;

  @override
  List<Object?> get props => [
        userPermit,
        snackbarMessage,
        selectedPhoneCountry,
        selectedCarNationality,
        drivingLicenseFile,
        carRegistrationFile,
      ];
}

class UserPermitDetailsInitial extends UserPermitDetailsState {}

class UserPermitDetailsLoading extends UserPermitDetailsState {}

class UserPermitDetailsLoaded extends UserPermitDetailsState {
  const UserPermitDetailsLoaded({super.userPermit, super.snackbarMessage});
}

class UserPermitDetailsError extends UserPermitDetailsState {
  const UserPermitDetailsError({super.snackbarMessage});
}

class UserPermitDetailsUpdated extends UserPermitDetailsState {
  const UserPermitDetailsUpdated({
    super.selectedPhoneCountry,
    super.selectedCarNationality,
    super.drivingLicenseFile,
    super.carRegistrationFile,
  });
}
