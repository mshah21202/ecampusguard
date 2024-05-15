part of 'update_request_cubit.dart';

abstract class UpdateRequestState extends Equatable {
  const UpdateRequestState({
    this.id,
    this.snackBarMessage,
    this.requests,
    this.selectedRequests,
  });

  final String? snackBarMessage;
  final int? id;
  final List<UpdateRequestDto>? requests;
  final List<UpdateRequestDto>? selectedRequests;

  @override
  List<Object?> get props => [
        id,
        snackBarMessage,
        requests,
        selectedRequests,
      ];
}

class UpdateRequestInitial extends UpdateRequestState {}

class UpdateRequestLoading extends UpdateRequestState {}

class UpdateRequestEmpty extends UpdateRequestState {}

class UpdateRequestLoaded extends UpdateRequestState {
  final List<UpdateRequestDto> requests;
  const UpdateRequestLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class UpdateRequestAccepted extends UpdateRequestState {
  final String message;
  const UpdateRequestAccepted(this.message, Object object);

  @override
  List<Object> get props => [message];
}

class UpdateRequestRejected extends UpdateRequestState {
  final String message;
  const UpdateRequestRejected(this.message, Object object);

  @override
  List<Object> get props => [message];
}

class UpdateRequestError extends UpdateRequestState {
  final String errorMessage;
  const UpdateRequestError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UpdateRequestRowSelection extends UpdateRequestState {
  final List<UpdateRequestDto> selectedRequests;
  const UpdateRequestRowSelection({required this.selectedRequests});

  @override
  List<Object> get props => [selectedRequests];
}

class RowTappedState extends UpdateRequestState {
  const RowTappedState({required super.id});
}

class UpdateRequestParamsUpdate extends UpdateRequestState {
  final UpdateRequestParams params;
  const UpdateRequestParamsUpdate({required this.params});

  @override
  List<Object?> get props => [params];
}
