import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'home_admin_state.dart';

class HomeAdminCubit extends Cubit<HomeAdminState> {
  HomeAdminCubit() : super(HomeAdminInitial()) {
    loadData();
  }

  final Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();

  List<ApplicationSummaryDto> applicationSummaries = [];

  List<AreaDto> areaSummaries = [];

  void loadData() {
    _loadApplicationsSummaries();
    _loadAreasSummaries();
  }

  void _loadApplicationsSummaries() async {
    emit(HomeAdminLoading());

    try {
      var result =
          await _api.getPermitApplicationApi().permitApplicationSummaryGet();

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      applicationSummaries = result.data!;

      emit(HomeAdminLoaded(
        applicationSummaries: applicationSummaries,
      ));
    } catch (e) {
      emit(HomeAdminError(snackBarMessage: e.toString()));
    }
  }

  void _loadAreasSummaries() async {
    emit(HomeAdminLoading());

    try {
      var result = await _api.getAreaApi().areaGet(headers: {
        "x-mock-response-name": "S",
      });

      if (result.data == null) {
        throw Exception(result.statusMessage);
      }

      areaSummaries = result.data!;

      emit(HomeAdminLoaded(
        areaSummaries: areaSummaries,
      ));
    } catch (e) {
      emit(HomeAdminError(snackBarMessage: e.toString()));
    }
  }
}
