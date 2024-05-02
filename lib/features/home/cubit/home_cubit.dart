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
      // var result = await _api
      //     .getPermitApplicationApi()
      //     .permitApplicationGet(orderBy: PermitApplicationOrderBy.Status);

      // if (result.data == null) {
      //   throw Exception(result.statusMessage);
      // }

      // emit(
      //   ApplicationStatusState(applicationStatus: result.data!.first.status),
      // );

      // var result =
      //     await _testApplicationStatus(PermitApplicationStatus.AwaitingPayment);
      // emit(ApplicationStatusState(status: result));
    } catch (e) {}
  }

  Future<void> fetchUserPermitDto() async {
    emit(LoadingHomeState());
    try {
      var result = await _api.getUserPermitApi().userPermitRelevantGet();

      if (result.data == null) {
        emit(ErrorHomeState(snackbarMessage: result.statusMessage));
        return;
      }

      // var result = await _testPermitStatus(UserPermitStatus.Withdrawn);
      userPermit = result.data;
      emit(LoadedHomeState(
        userPermit: result.data,
        // homeScreenDto: homeScreenDto,
      ));
    } catch (e) {
      emit(ErrorHomeState(snackbarMessage: e.toString()));
    }
  }

  /// Testing purposes only
  Future<PermitApplicationStatus> _testApplicationStatus(
      PermitApplicationStatus status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return status;
  }

  /// Testing purposes only
  Future<UserPermitStatus> _testPermitStatus(UserPermitStatus status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return status;
  }
}
