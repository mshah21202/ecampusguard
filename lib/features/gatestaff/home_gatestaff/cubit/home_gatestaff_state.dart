part of 'home_gatestaff_cubit.dart';

class HomeGatestaffState extends Equatable {
  const HomeGatestaffState({
    this.snackbarMessage,
    this.areaScreens,
  });

  final String? snackbarMessage;
  final List<AreaScreenDto>? areaScreens;

  @override
  List<Object?> get props => [
        snackbarMessage,
        areaScreens,
      ];
}

class HomeGatestaffInitial extends HomeGatestaffState {}

class HomeGatestaffLoading extends HomeGatestaffState {}

class HomeGatestaffLoaded extends HomeGatestaffState {
  const HomeGatestaffLoaded({
    super.snackbarMessage,
    super.areaScreens,
  });
}

class HomeGatestaffError extends HomeGatestaffState {
  const HomeGatestaffError({super.snackbarMessage});
}
