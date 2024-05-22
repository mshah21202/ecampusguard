part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.permitApplication,
    this.userPermit,
    this.homeScreenDto,
    this.snackbarMessage,
    this.previousPermits,
  });

  final HomeScreenDto? homeScreenDto;
  final PermitApplicationInfoDto? permitApplication;
  final UserPermitDto? userPermit;
  final String? snackbarMessage;
  final List<UserPermitDto>? previousPermits;

  @override
  List<Object?> get props => [
        permitApplication,
        userPermit,
        homeScreenDto,
        snackbarMessage,
        previousPermits,
      ];
}

class HomeInitial extends HomeState {}

class LoadingHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  const LoadedHomeState({
    super.homeScreenDto,
    super.permitApplication,
    super.userPermit,
    super.previousPermits,
  });
}

class ErrorHomeState extends HomeState {
  const ErrorHomeState({super.snackbarMessage});
}
