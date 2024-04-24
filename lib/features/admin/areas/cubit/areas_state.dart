part of 'areas_cubit.dart';

class AreasState extends Equatable {
  const AreasState(
      {this.areas, this.area, this.snackbarMessage, this.selectedAreas});

  final List<AreaDto>? areas;
  final List<AreaDto>? selectedAreas;
  final String? snackbarMessage;
  final AreaDto? area;

  @override
  List<Object> get props => [
        areas ?? [],
        selectedAreas ?? [],
        snackbarMessage ?? "",
        area ?? 0,
      ];
}

class AreasInitial extends AreasState {}

class AreasLoading extends AreasState {}

class AreasLoaded extends AreasState {
  const AreasLoaded({super.areas, super.area, super.snackbarMessage});
}

class AreasRowSelectionUpdate extends AreasState {
  const AreasRowSelectionUpdate({super.selectedAreas});
}

class AreasError extends AreasState {
  const AreasError({super.snackbarMessage});
}

class AreasOnRowTap extends AreasState {
  const AreasOnRowTap({required super.area});
}
