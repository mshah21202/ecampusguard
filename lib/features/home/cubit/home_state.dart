part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({this.applicationStatus, this.permitStatus});
  final PermitApplicationStatusEnum? applicationStatus;
  final UserPermitStatus? permitStatus;

  @override
  List<Object> get props => [
        applicationStatus ?? PermitApplicationStatusEnum.unknownDefaultOpenApi,
        permitStatus ?? UserPermitStatus.unknownDefaultOpenApi
      ];
}

class HomeInitial extends HomeState {}

class LoadingHomeState extends HomeState {}

class ApplicationStatusState extends HomeState {
  const ApplicationStatusState({required this.status})
      : super(applicationStatus: status);

  final PermitApplicationStatusEnum status;
}

class PermitStatusState extends HomeState {
  const PermitStatusState({required this.status}) : super(permitStatus: status);

  final UserPermitStatus status;
}
