import 'package:bloc/bloc.dart';
import 'package:ecampusguard/global/helpers/user_permits_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'user_permits_state.dart';

class UserPermitsCubit extends Cubit<UserPermitsState> {
  UserPermitsCubit({required this.params}) : super(UserPermitsInitial()) {
    userPermitsDataSource = UserPermitsDataSource.fromApi(
      fetchFunction: getUserPermits,
      cubit: this,
    );

    loadPermits();
  }

  late UserPermitsDataSource userPermitsDataSource;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  UserPermitsParams params;
  List<UserPermitDto> userPermits = [];
  List<PermitDto> permits = [];

  void loadPermits() async {
    emit(UserPermitsLoading());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data!.toList();
    }

    emit(UserPermitsLoaded(permits: permits));
  }

  void setQueryParams({
    required UserPermitsParams params,
    bool updateDatasource = true,
  }) {
    this.params = UserPermitsParams(
      pageSize: params.pageSize ?? this.params.pageSize ?? 10,
      currentPage: params.currentPage ?? this.params.currentPage ?? 0,
      plateNumber: params.plateNumber,
      studentId: params.studentId,
      status: params.status,
      permitId: params.permitId,
      orderBy: params.orderBy,
      orderByDirection: params.orderByDirection,
    );
    updateDatasource ? userPermitsDataSource.refreshDatasource() : null;

    emit(UserPermitsParamsUpdate(params: this.params));
  }

  void onPageChanged(int? page) {
    params = UserPermitsParams(
      pageSize: params.pageSize,
      currentPage: page,
      plateNumber: params.plateNumber,
      studentId: params.studentId,
      status: params.status,
      permitId: params.permitId,
      orderBy: params.orderBy,
      orderByDirection: params.orderByDirection,
    );
    setQueryParams(params: params);
  }

  void onRowTap(int index) {
    emit(UserPermitsOnRowTap(id: userPermits[index].permit!.id!));
  }

  Future<List<UserPermitDto>> getUserPermits(int startIndex, int count) async {
    emit(UserPermitsLoading());
    try {
      var result = await _api.getUserPermitApi().userPermitGet(
            pageNumber: params.currentPage ?? 0,
            pageSize: params.pageSize ?? 10,
            plateNumber: params.plateNumber,
            studentId: params.studentId,
            permitId: params.permitId,
            status: params.status,
            orderBy: params.orderBy,
            orderByDirection: params.orderByDirection,
          );

      if (result.data == null) {
        emit(UserPermitsError(snackbarMessage: result.statusMessage));
        return [];
      }

      userPermits = result.data!;
      emit(UserPermitsLoaded(userPermits: userPermits));
      return userPermits;
    } catch (e) {
      emit(UserPermitsError(snackbarMessage: e.toString()));
      return [];
    }
  }
}
