part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}
class ApplicationStatusState extends HomeState {
  final PermitApplicationStatus applicationStatus;

  const ApplicationStatusState(this.applicationStatus);

  @override
  List<Object> get props => [applicationStatus];
}

//status we have
enum PermitApplicationStatus { valid,withdraw, pending, awaitingPayment, approved, rejected }