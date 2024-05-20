part of 'update_request_cubit.dart';

abstract class UpdateRequestState extends Equatable {
  const UpdateRequestState({
    this.id,
    this.snackBarMessage,
    this.requests,
    this.selectedRequests,
    this.request,
    this.params,
  });

  final String? snackBarMessage;
  final int? id;
  final List<UpdateRequestDto>? requests;
  final UpdateRequestDto? request;
  final List<UpdateRequestDto>? selectedRequests;
  final UpdateRequestParams? params;
  @override
  List<Object?> get props => [
        id,
        snackBarMessage,
        requests,
        selectedRequests,
        params,
        request,
      ];
}

class UpdateRequestInitial extends UpdateRequestState {}

class UpdateRequestLoading extends UpdateRequestState {}

class UpdateRequestEmpty extends UpdateRequestState {}

class UpdateRequestLoaded extends UpdateRequestState {
  const UpdateRequestLoaded({
    super.requests,
    super.request,
    super.snackBarMessage,
  });
}

class UpdateRequestError extends UpdateRequestState {
  const UpdateRequestError({super.snackBarMessage});
}

class UpdateRequestRowSelection extends UpdateRequestState {
  const UpdateRequestRowSelection({super.selectedRequests});
}

class RowTappedState extends UpdateRequestState {
  const RowTappedState({required super.id});
}

class UpdateRequestParamsUpdate extends UpdateRequestState {
  const UpdateRequestParamsUpdate({required super.params});
}
