part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.snackbarMessage,
    this.role,
    this.username,
  });

  final String? snackbarMessage;
  final String? username;
  final Role? role;

  @override
  List<Object?> get props => [
        snackbarMessage,
        username,
        role,
      ];
}

class AuthenticationInitial extends AuthenticationState {}

class LoadingAuthentication extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  const Authenticated({required super.username, required super.role});
}

class LoginFailedAuthentication extends AuthenticationState {
  const LoginFailedAuthentication({super.snackbarMessage});
}

class RegisterFailedAuthentication extends AuthenticationState {
  const RegisterFailedAuthentication({super.snackbarMessage});
}

class Unauthenticated extends AuthenticationState {}

class TimedOutAuthentication extends AuthenticationState {}
