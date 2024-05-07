part of 'area_screen_cubit.dart';

class AreaScreenState extends Equatable {
  const AreaScreenState(
      {this.snackbarMessage,
      this.areaScreen,
      this.anplrResult,
      this.resultSeq,
      this.connected});

  final String? snackbarMessage;
  final AreaScreenDto? areaScreen;
  final AnplrResultDto? anplrResult;
  final int? resultSeq;
  final bool? connected;

  @override
  List<Object?> get props => [
        snackbarMessage,
        areaScreen,
        anplrResult,
        resultSeq,
        connected,
      ];
}

class AreaScreenInitial extends AreaScreenState {}

class AreaScreenLoading extends AreaScreenState {}

class HubConnectionLoading extends AreaScreenState {
  const HubConnectionLoading({super.snackbarMessage});
}

class AreaScreenLoaded extends AreaScreenState {
  const AreaScreenLoaded({
    super.areaScreen,
    super.snackbarMessage,
    super.anplrResult,
    super.resultSeq,
    super.connected,
  });
}

class AreaScreenError extends AreaScreenState {
  const AreaScreenError({super.snackbarMessage});
}
