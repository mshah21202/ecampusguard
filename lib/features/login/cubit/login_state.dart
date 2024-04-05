part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  const LoginFailure({required this.error});
  final String? error;
}
