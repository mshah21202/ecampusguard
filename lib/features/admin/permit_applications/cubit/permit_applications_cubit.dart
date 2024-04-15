import 'package:bloc/bloc.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'permit_applications_state.dart';

class PermitApplicationsCubit extends Cubit<PermitApplicationsState> {
  PermitApplicationsCubit({required this.params})
      : super(PermitApplicationsInitial()) {
    applicationsDataSource = PermitApplicationsDataSource.fromApi(
      fetchFunction: getPermitApplications,
    );
  }

  List<PermitApplicationInfoDto> applications = [];
  List<PermitDto> permits = [];
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  late PermitApplicationsDataSource applicationsDataSource;
  PermitApplicationsParams params;
  int? sortColumnIndex;

  void loadPermits() async {
    emit(LoadingPermitApplications());
    var result = await _api.getPermitsApi().permitsGet();

    if (result.data != null) {
      permits = result.data!.toList();
    }

    emit(const LoadedPermitApplications());
  }

  void setQueryParams({
    int? pageSize,
    int? currentPage,
    String? studentId,
    String? name,
    AcademicYear? academicYear,
    int? permitId,
    PermitApplicationStatus? status,
    PermitApplicationOrderBy? orderBy,
    int? sortColumnIndex,
    String? orderByDirection,
  }) {
    params = PermitApplicationsParams(
      pageSize: pageSize ?? params.pageSize,
      currentPage: currentPage ?? params.currentPage,
      studentId: studentId ?? params.studentId,
      name: name ?? params.name,
      status: status ?? params.status,
      academicYear: academicYear ?? params.academicYear,
      permitId: permitId ?? params.permitId,
      orderBy: orderBy ?? params.orderBy,
      orderByDirection: orderByDirection ?? params.orderByDirection,
    );
    this.sortColumnIndex = sortColumnIndex ?? this.sortColumnIndex;
    applicationsDataSource.refreshDatasource();
    emit(SetQueryParamsPermitApplications(
      pageSize: params.pageSize,
      currentPage: params.currentPage,
      studentId: params.studentId,
      name: params.name,
      status: params.status,
      academicYear: params.academicYear,
      permitId: params.permitId,
      orderBy: params.orderBy,
      orderByDirection: params.orderByDirection,
    ));
  }

  Future<List<PermitApplicationInfoDto>> getPermitApplications(
      int startIndex, int count) async {
    emit(LoadingPermitApplications());
    try {
      var result = await _api.getPermitApplicationApi().permitApplicationGet(
        headers: {"x-mock-response-name": "Success2"},
        pageSize: params.pageSize,
        pageNumber: params.currentPage,
        status: params.status,
        studentId: params.studentId,
        name: params.name,
        year: params.academicYear,
        permitId: params.permitId,
        orderBy: params.orderBy,
        orderByDirection: params.orderByDirection,
      );

      if (result.data == null) {
        emit(ErrorPermitApplications(snackBarMessage: result.statusMessage));
        return [];
      }

      emit(LoadedPermitApplications(applications: result.data));
      return result.data!;
    } catch (e) {
      emit(ErrorPermitApplications(snackBarMessage: e.toString()));
      return [];
    }
  }
}
