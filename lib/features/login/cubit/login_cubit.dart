import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../authentication/cubit/authentication_cubit.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  LoginCubit(this.AuthCubit) : super(LoginInitial());

  final AuthenticationCubit AuthCubit;

  void login(String username,String password){
    emit(LoginLaoding());

    AuthCubit.login(username: username, password: password);

    AuthCubit.stream.listen((state) {

      if(state is Authenticated) {
        emit(LoginSuccess());
      }
        else if(state is FailedAuthentication){
        emit(LoginFailure(error: 'ERROR'));
      }



      }

    );
  }
}
