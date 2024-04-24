part of 'permits_cubit.dart';

class PermitsState extends Equatable {
  const PermitsState({
    this.snackbarMessage,
    this.permits,
    this.areas,
    this.permit,
    this.selectedPermits,
    this.selectedDays,
  });

  final String? snackbarMessage;
  final List<PermitDto>? permits;
  final List<PermitDto>? selectedPermits;
  final List<AreaDto>? areas;
  final PermitDto? permit;
  final List<String>? selectedDays;

  @override
  List<Object> get props => [
        snackbarMessage ?? "",
        permits ?? [],
        areas ?? [],
        permit ?? 0,
        selectedPermits ?? [],
        selectedDays ?? [],
      ];
}

class PermitsInitial extends PermitsState {}

class PermitsLoading extends PermitsState {}

class PermitsLoaded extends PermitsState {
  const PermitsLoaded({
    super.snackbarMessage,
    super.permits,
    super.permit,
    super.areas,
    super.selectedDays,
  });
}

class PermitsError extends PermitsState {
  const PermitsError({super.snackbarMessage});
}

class PermitsOnRowTap extends PermitsState {
  const PermitsOnRowTap({required super.permit});
}

class PermitsRowSelectionUpdate extends PermitsState {
  const PermitsRowSelectionUpdate({super.selectedPermits});
}
