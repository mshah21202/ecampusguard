import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
// import 'package:get_it/get_it.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    _getHomeScreenWidgets();
  }

  final Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();
  HomeScreenDto? homeScreenDto;
  UserPermitDto? userPermit;
  PermitApplicationInfoDto? permitApplication;
  List<UserPermitDto> previousPermits = [];

  void _getHomeScreenWidgets() async {
    emit(LoadingHomeState());
    try {
      var result = await _api.getHomeScreenApi().homeScreenGet();

      if (result.data == null) {
        emit(ErrorHomeState(snackbarMessage: result.statusMessage));
      }

      homeScreenDto = result.data;
      emit(LoadedHomeState(homeScreenDto: homeScreenDto));
    } catch (e) {
      emit(ErrorHomeState(snackbarMessage: e.toString()));
    }
  }

  Future<void> fetchApplicationStatus() async {
    emit(LoadingHomeState());
    try {
      var result = await _api
          .getPermitApplicationApi()
          .permitApplicationGet(orderBy: PermitApplicationOrderBy.Status);

      if (result.data == null) {
        emit(ErrorHomeState(snackbarMessage: result.statusMessage));
        return;
      }
      if (result.data!.isNotEmpty &&
          result.data!.first.status != PermitApplicationStatus.Denied) {
        permitApplication = result.data!.first;
      }
      emit(LoadedHomeState(permitApplication: permitApplication));
      fetchPreviousPermits();
      return;
    } catch (e) {
      emit(ErrorHomeState(snackbarMessage: e.toString()));
    }
  }

  Future<void> fetchUserPermitDto() async {
    emit(LoadingHomeState());
    try {
      var result = await _api.getUserPermitsApi().userPermitsRelevantGet();

      if (result.data == null) {
        emit(ErrorHomeState(snackbarMessage: result.statusMessage));
        return;
      }

      // var result = await _testPermitStatus(UserPermitStatus.Withdrawn);
      userPermit = result.data;
      emit(
        LoadedHomeState(
          userPermit: result.data,
          homeScreenDto: homeScreenDto,
        ),
      );
    } catch (e) {
      emit(ErrorHomeState(snackbarMessage: e.toString()));
    }
  }

  void fetchPreviousPermits() async {
    emit(LoadingHomeState());
    try {
      var result = await _api.getUserPermitsApi().userPermitsGet();

      if (result.data == null) {
        emit(ErrorHomeState(snackbarMessage: result.statusMessage));
        return;
      }

      previousPermits = result.data!;
      emit(LoadedHomeState(previousPermits: previousPermits));
      return;
    } catch (e) {
      emit(ErrorHomeState(snackbarMessage: e.toString()));
      return;
    }
  }

  void onPay() async {
    await _api
        .getPermitApplicationApi()
        .permitApplicationPayIdPost(id: permitApplication!.id!);
    _getHomeScreenWidgets();
  }
}
