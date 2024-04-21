import 'package:bloc/bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'permits_state.dart';

class PermitsCubit extends Cubit<PermitsState> {
  PermitsCubit() : super(PermitsInitial()) {
    permitsDataSource =
        PermitsDataSource.fromApi(fetchFunction: getPermits, cubit: this);

    loadAreas();
  }

  late PermitsDataSource permitsDataSource;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  List<PermitDto> permits = [];
  List<PermitDto> selectedPermits = [];
  List<AreaDto> areas = [];
  int pageSize = 10;

  final List<String> _attendingDays = [
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
  ];

  void onRowTap(int index) {
    emit(PermitsOnRowTap(permit: permits[index]));
    emit(const PermitsLoaded());
  }

  void selectedRowsListener() {
    selectedPermits = permitsDataSource.selectionState == SelectionState.include
        ? permitsDataSource.selectionRowKeys
            .map((key) => permits[(key as ValueKey<int>).value])
            .toList()
        : permits.indexed
            .where((element) => !permitsDataSource.selectionRowKeys
                .contains(ValueKey(element.$1)))
            .map((e) => e.$2)
            .toList();

    if (permitsDataSource.selectionState == SelectionState.none) {
      selectedPermits = [];
    }

    emit(PermitsRowSelectionUpdate(selectedPermits: selectedPermits));
  }

  void loadAreas() async {
    emit(PermitsLoading());
    try {
      var result = await _api.getAreaApi().areaGet();

      if (result.data == null) {
        emit(PermitsError(snackbarMessage: result.statusMessage));
        return;
      }

      areas = result.data!;
      emit(PermitsLoaded(areas: areas));
    } catch (e) {
      emit(PermitsError(snackbarMessage: e.toString()));
    }
  }

  Future<List<PermitDto>> getPermits(int startIndex, int count) async {
    emit(PermitsLoading());
    try {
      var result = await _api.getPermitsApi().permitsGet(
            pageNumber: startIndex ~/ count,
            pageSize: pageSize,
          );

      if (result.data == null) {
        emit(PermitsError(snackbarMessage: result.statusMessage));
        return permits;
      }

      permits = result.data!;
      emit(PermitsLoaded(permits: permits));
    } catch (e) {
      emit(PermitsError(snackbarMessage: e.toString()));
    }

    return permits;
  }

  void onPageChanged(int page) {
    permitsDataSource.refreshDatasource();
  }

  Future<void> onDelete({int? index}) async {
    emit(PermitsLoading());
    try {
      if (index == null) {
        for (var permit in selectedPermits) {
          var result =
              await _api.getPermitsApi().permitsIdDelete(id: permit.id!);

          if (result.data == null) {
            emit(PermitsError(snackbarMessage: result.statusMessage));
            return;
          }
        }
        permitsDataSource.refreshDatasource();
        permitsDataSource.deselectAll();
        emit(const PermitsLoaded(
            snackbarMessage: "Successfully deleted permit(s)"));
      } else {
        var result =
            await _api.getPermitsApi().permitsIdDelete(id: permits[index].id!);

        if (result.data == null) {
          emit(PermitsError(snackbarMessage: result.statusMessage));
          return;
        }

        permitsDataSource.refreshDatasource();
        permitsDataSource.deselectAll();
        emit(const PermitsLoaded(
            snackbarMessage: "Successfully deleted permit"));
      }
    } catch (e) {
      emit(PermitsError(snackbarMessage: e.toString()));
    }
  }

  String attendingDaysString(List<bool> bools) {
    List<String> result = [];
    for (int i = 0; i < 5; i++) {
      if (bools[i]) {
        result.add(_attendingDays[i]);
      }
    }

    return result.join(',');
  }
}
