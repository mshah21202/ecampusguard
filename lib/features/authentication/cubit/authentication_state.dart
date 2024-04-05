part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class LoadingAuthentication extends AuthenticationState {}

class Authenticated extends AuthenticationState {}

class LoginFailedAuthentication extends AuthenticationState {
  const LoginFailedAuthentication({this.message});

  final String? message;
}

class RegisterFailedAuthentication extends AuthenticationState {
  const RegisterFailedAuthentication({this.message});

  final String? message;
}

class Unauthenticated extends AuthenticationState {}

class TimedOutAuthentication extends AuthenticationState {}
