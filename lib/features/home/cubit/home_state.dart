part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.permitApplication,
    this.userPermit,
    this.homeScreenDto,
    this.snackbarMessage,
  });

  final HomeScreenDto? homeScreenDto;
  final PermitApplicationInfoDto? permitApplication;
  final UserPermitDto? userPermit;
  final String? snackbarMessage;

  @override
  List<Object?> get props => [
        permitApplication,
        userPermit,
        homeScreenDto,
        snackbarMessage,
      ];
}

class HomeInitial extends HomeState {}

class LoadingHomeState extends HomeState {}

class LoadedHomeState extends HomeState {
  const LoadedHomeState({
    super.homeScreenDto,
    super.permitApplication,
    super.userPermit,
  });
}

class ErrorHomeState extends HomeState {
  const ErrorHomeState({super.snackbarMessage});
}
