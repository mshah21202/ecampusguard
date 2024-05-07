import 'package:bloc/bloc.dart';
import 'package:ecampusguard/global/consts.dart';
import 'package:ecampusguard/global/helpers/signalr_helper.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'area_screen_state.dart';

class AreaScreenCubit extends Cubit<AreaScreenState> {
  AreaScreenCubit({required this.areaId}) : super(AreaScreenInitial());

  late SignalRHelper _anplrSignalR;
  final SharedPreferences _prefs = GetIt.I.get<SharedPreferences>();
  final int areaId;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  AreaScreenDto? areaScreen;
  AnplrResultDto? anplrResult;

  bool connected = false;

  void connectToHub() async {
    emit(const HubConnectionLoading());
    try {
      _anplrSignalR = SignalRHelper(
        clientMethods: {
          "ReceiveAnplrResult": onReceiveAnplr,
        },
        fullPath: "${_api.dio.options.baseUrl}/Area/feed/$areaId",
        bearerToken: _prefs.getString(USER_TOKEN_KEY) ?? "",
        onClose: onConnectionClose,
        onReconnecting: onConnectionReconnecting,
        onReconnected: onConnectionReconnected,
      );

      await _anplrSignalR.connect();

      connected = true;

      emit(const AreaScreenLoaded(
        snackbarMessage: "Successfully connected to live feed.",
      ));
    } catch (e) {
      emit(AreaScreenError(snackbarMessage: e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _anplrSignalR.disconnect();
    super.close();
  }

  void onConnectionClose({Exception? error}) {
    connected = false;
    emit(AreaScreenLoaded(
      connected: connected,
      snackbarMessage: "Lost connectiong to live feed. Could not reconnect.",
    ));
  }

  void onConnectionReconnecting({Exception? error}) {
    connected = false;
    emit(const HubConnectionLoading(
      snackbarMessage: "Lost connection to live feed. Reconnecting...",
    ));
  }

  void onConnectionReconnected({String? connectionId}) {
    connected = true;
    emit(AreaScreenLoaded(
      connected: connected,
      snackbarMessage: "Successfully reconnected to live feed.",
    ));
  }

  Future<void> onReceiveAnplr(List<Object?>? args) async {
    if (args != null) {
      anplrResult =
          AnplrResultDto.fromJson((args.first as Map<String, dynamic>));

      emit(AreaScreenLoaded(
        anplrResult: anplrResult,
        resultSeq: (state.resultSeq ?? 0) + 1,
      ));
      getAreaScreen(loading: false);
    } else {
      emit(const AreaScreenError(
        snackbarMessage: "Could not read anplr results.",
      ));
    }
  }

  Future<void> getAreaScreen({bool loading = true}) async {
    if (loading) emit(AreaScreenLoading());
    try {
      var result = await _api.getAreaApi().areaDetailsIdGet(id: areaId);
      if (result.data == null) {
        emit(AreaScreenError(snackbarMessage: result.statusMessage));
        return;
      }

      areaScreen = result.data;
      emit(AreaScreenLoaded(
        areaScreen: areaScreen,
        resultSeq: (state.resultSeq ?? 0) + 1,
      ));
      return;
    } catch (e) {
      emit(AreaScreenError(snackbarMessage: e.toString()));
    }
  }
}
