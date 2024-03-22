part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLaoding extends LoginState{}
class LoginSuccess extends LoginState{}

class LoginFailure extends LoginState{
  String error;
  LoginFailure({required this.error});
}