part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class LoadingAuthentication extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class FailedAuthentication extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class TimedOutAuthentication extends AuthenticationState {}
