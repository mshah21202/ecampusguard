import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'home_gatestaff_state.dart';

class HomeGatestaffCubit extends Cubit<HomeGatestaffState> {
  HomeGatestaffCubit() : super(HomeGatestaffInitial());

  List<AreaScreenDto> areaScreens = [];
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();

  void getAreaScreens() async {
    emit(HomeGatestaffLoading());
    try {
      var result = await _api.getAreaApi().areaDetailsGet();

      if (result.data == null) {
        emit(HomeGatestaffError(snackbarMessage: result.statusMessage));
        return;
      }

      areaScreens = result.data!;
      emit(HomeGatestaffLoaded(areaScreens: areaScreens));
      return;
    } catch (e) {
      emit(HomeGatestaffError(snackbarMessage: e.toString()));
    }
  }
}
