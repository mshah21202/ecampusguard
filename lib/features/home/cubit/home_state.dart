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

//5 status we have
enum PermitApplicationStatus { Valid,Withdraw, Pending, AwaitingPayment, Expired}

class PreviousPermitsState extends HomeState {
  final List<dynamic> permits;

  const PreviousPermitsState(this.permits);

  @override
  List<Object> get props => [permits];
}
