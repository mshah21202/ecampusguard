part of 'user_permits_cubit.dart';

class UserPermitsState extends Equatable {
  const UserPermitsState({
    this.snackbarMessage,
    this.userPermits,
    this.params,
    this.permits,
    this.id,
  });

  final String? snackbarMessage;
  final UserPermitsParams? params;
  final List<UserPermitDto>? userPermits;
  final List<PermitDto>? permits;
  final int? id;

  @override
  List<Object?> get props => [
        snackbarMessage,
        userPermits,
        params,
        permits,
        id,
      ];
}

class UserPermitsInitial extends UserPermitsState {}

class UserPermitsParamsUpdate extends UserPermitsState {
  const UserPermitsParamsUpdate({required super.params});
}

class UserPermitsOnRowTap extends UserPermitsState {
  const UserPermitsOnRowTap({required super.id});
}

class UserPermitsLoading extends UserPermitsState {}

class UserPermitsLoaded extends UserPermitsState {
  const UserPermitsLoaded({
    super.snackbarMessage,
    super.userPermits,
    super.permits,
  });
}

class UserPermitsError extends UserPermitsState {
  const UserPermitsError({super.snackbarMessage});
}
