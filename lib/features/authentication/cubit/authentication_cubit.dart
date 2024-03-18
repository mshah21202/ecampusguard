import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();

  void login({required String username, required String password}) async {
    emit(LoadingAuthentication());

    try {
      var result = await _api.getAuthenticationApi().authenticationLoginPost(
        loginDto: LoginDto(
          (b) {
            b.username = username;
            b.password = password;
          },
        ),
      );

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      var data = result.data!;

      if (data.code == AuthResponseCode.Authenticated) {
        // Set authentication object in api
        _setAuthentication(data.token);

        emit(Authenticated());
      } else {
        emit(FailedAuthentication(message: data.error.toString()));
      }
    } catch (e) {
      emit(FailedAuthentication(message: e.toString()));
    }
  }

  void register({required String username, required String password}) async {
    try {
      var result = await _api.getAuthenticationApi().authenticationRegisterPost(
        registerDto: RegisterDto(
          (b) {
            b.name = username;
            b.password = password;
          },
        ),
      );

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      var data = result.data!;

      if (data.code == AuthResponseCode.RegisteredAndAuthenticated) {
        // Set authentication object in api
        _setAuthentication(data.token);

        emit(Authenticated());
      }
    } catch (e) {
      emit(FailedAuthentication());
    }
  }

  /// Sets the bearer authentication for the API and saves the token in the preferences.
  ///
  /// If [token] is null, then it deletes auth object and removes token from preferences.
  void _setAuthentication(String? token) {
    if (token == null || token == '') {
      // TODO: Save token in prefs

      _api.setBearerAuth('Bearer', token!);
    } else {
      // TODO: Remove token from prefs

      (_api.dio.interceptors
                  .firstWhere((element) => element is BearerAuthInterceptor)
              as BearerAuthInterceptor)
          .tokens
          .remove('Bearer');
    }
  }
}
