import 'package:bloc/bloc.dart';
import 'package:ecampusguard/global/consts.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_state.dart';

enum Role {
  user,
  admin,
  gateStaff,
}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial()) {
    loadTokensFromPrefs();
  }

  final Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();
  final SharedPreferences _prefs = GetIt.instance.get<SharedPreferences>();
  Role? role;
  String? username;

  void login({required String username, required String password}) async {
    emit(LoadingAuthentication());

    try {
      var result = await _api.getAuthenticationApi().authenticationLoginPost(
            loginDto: LoginDto(username: username, password: password),
            validateStatus: (status) => true,
          );

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      var data = result.data!;

      if (data.code == AuthResponseCode.Authenticated) {
        // Set authentication object in api
        _setAuthentication(data.token);

        emit(Authenticated(
          username: username,
          role: role,
        ));
      } else {
        emit(LoginFailedAuthentication(snackbarMessage: data.error.toString()));
      }
    } catch (e) {
      emit(LoginFailedAuthentication(snackbarMessage: e.toString()));
    }
  }

  void register(
      {required String name,
      required String username,
      required String password}) async {
    try {
      emit(LoadingAuthentication());
      var result = await _api.getAuthenticationApi().authenticationRegisterPost(
            registerDto: RegisterDto(
              name: name,
              username: username,
              password: password,
            ),
          );

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      var data = result.data!;

      if (data.code == AuthResponseCode.RegisteredAndAuthenticated) {
        // Set authentication object in api
        _setAuthentication(data.token);

        emit(Authenticated(
          username: username,
          role: role,
        ));
      } else {
        emit(RegisterFailedAuthentication(
            snackbarMessage: data.error.toString()));
      }
    } catch (e) {
      emit(RegisterFailedAuthentication(snackbarMessage: e.toString()));
    }
  }

  void logout() {
    _setAuthentication(null);
    emit(Unauthenticated());
  }

  bool isValidSession() {
    String? token = _prefs.getString(USER_TOKEN_KEY);

    if (!_isValidToken(token)) {
      return false;
    }

    return true;
  }

  /// Looks for the user token in Shared Preferences checks validity of the
  /// token. And then reconstructs a new [EmployeeAppMcfApi] with a new [HttpBearerAuth]
  /// containing the token. Returns [true] if token is valid, [false] if token
  /// is not found, or invalid.
  ///
  /// Emits:
  ///
  ///   - [AuthenticatedState] if token is valid.
  ///   - [UnauthenticatedState] if token is not valid (expired, corrupt, etc).
  ///   or if token was not found in shared preferences.
  bool loadTokensFromPrefs() {
    emit(LoadingAuthentication());
    String? token = _prefs.getString(USER_TOKEN_KEY);

    if (!_isValidToken(token)) {
      emit(Unauthenticated());
      return false;
    }

    _setAuthentication(token);

    emit(Authenticated(
      username: username,
      role: role,
    ));
    return true;
  }

  /// Checks if the token is valid (Not null && not empty && not expired && valid)
  bool _isValidToken(String? token) {
    if (token == null ||
        token == "" ||
        JwtDecoder.tryDecode(token) == null ||
        JwtDecoder.isExpired(token)) {
      return false;
    }

    return true;
  }

  /// Sets the bearer authentication for the API and saves the token in the preferences.
  ///
  /// If [token] is null, then it deletes auth object and removes token from preferences.
  void _setAuthentication(String? token) {
    if (token != null && token != '') {
      _prefs.setString(USER_TOKEN_KEY, token);

      var roleToken = JwtDecoder.decode(token)["role"];
      var usernameToken = JwtDecoder.decode(token)["unique_name"].toString();

      username = usernameToken;

      switch (roleToken as String) {
        case "Admin":
          role = Role.admin;
          break;
        case "GateStaff":
          role = Role.gateStaff;
          break;
        default:
          role = Role.user;
          break;
      }

      _api.setBearerAuth('Bearer', token);
    } else {
      _prefs.remove(USER_TOKEN_KEY);
      role = null;
      username = null;

      (_api.dio.interceptors
                  .firstWhere((element) => element is BearerAuthInterceptor)
              as BearerAuthInterceptor)
          .tokens
          .remove('Bearer');
    }
  }
}
