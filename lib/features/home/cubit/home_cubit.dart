import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final Ecampusguardapi _api = GetIt.instance.get<Ecampusguardapi>();



  void fetchApplicationStatus() async {
    try {
      var status = await _fetchStatusFromBackend();
      emit(ApplicationStatusState(status));
    } catch (error) {
      //error
    }
  }

  Future<PermitApplicationStatus> _fetchStatusFromBackend() async {
    //for now
    return PermitApplicationStatus.Pending;
  }


  void fetchPreviousPermits(int userId) async {
    try {
      //for now (crying emoji)
      var permits = [];
      emit(PreviousPermitsState(permits));
    } catch (error) {
      //error
    }
  }
}
