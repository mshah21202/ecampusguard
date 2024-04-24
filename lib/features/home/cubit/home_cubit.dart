import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
// import 'package:get_it/get_it.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial()) {
    _loadData();
  }

  // final Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();

  void _loadData() async {
     await fetchApplicationStatus();
    // await fetchPermitStatus();
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

      var result =
          await _testApplicationStatus(PermitApplicationStatus.AwaitingPayment);
      emit(ApplicationStatusState(status: result));
    } catch (error) {}
  }

  Future<void> fetchPermitStatus() async {
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
      var result = await _testPermitStatus(UserPermitStatus.Withdrawn);
      emit(PermitStatusState(status: result));
    } catch (error) {}
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
