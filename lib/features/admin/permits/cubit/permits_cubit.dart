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
  PermitDto? permit;
  List<PermitDto> selectedPermits = [];
  List<AreaDto> areas = [];
  int pageSize = 10;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController permitNameController = TextEditingController();
  final TextEditingController permitPriceController = TextEditingController();
  final TextEditingController permitCapacityController =
      TextEditingController();
  int? areaIndex;

  Map<String, bool> _permitDays = {
    "Sun": false,
    "Mon": false,
    "Tue": false,
    "Wed": false,
    "Thu": false,
  };

  List<String> get permitDays => _permitDays.keys.toList();
  List<String> get selectedDays =>
      (Map<String, bool>.from(_permitDays)..removeWhere((key, value) => !value))
          .keys
          .toList();

  void onChangedDays(List<String> selectedDays) {
    _permitDays
        .updateAll((key, value) => selectedDays.contains(key) ? true : false);

    emit(PermitsLoaded(selectedDays: this.selectedDays));
  }

  void onRowTap(int index) {
    emit(PermitsOnRowTap(permit: permits[index]));
    emit(const PermitsLoaded());
  }

  void getPermit(int id) async {
    emit(PermitsLoading());
    try {
      var result = await _api.getPermitsApi().permitsIdGet(id: id);

      if (result.data == null) {
        emit(PermitsError(snackbarMessage: result.statusMessage));
        return;
      }
      permit = result.data;
      await populateFields();
      emit(PermitsLoaded(permit: permit));
    } catch (e) {
      emit(PermitsError(snackbarMessage: e.toString()));
    }
  }

  Future<void> populateFields({bool clear = false}) async {
    permitNameController.text = clear ? "" : permit!.name!;
    permitPriceController.text = clear ? "" : permit!.price.toString();
    permitCapacityController.text = clear ? "" : permit!.capacity.toString();
    if (areas.isEmpty) {
      await loadAreas();
    }
    areaIndex =
        clear ? null : areas.indexWhere((area) => area.id == permit!.area!.id);
    areaIndex = areaIndex == -1 ? null : areaIndex;
    if (clear) {
      _permitDays.updateAll((key, value) => false);
    } else {
      int i = 0;
      _permitDays.updateAll((key, value) {
        i++;
        return permit!.days!.elementAtOrNull(i - 1) ?? false;
      });
    }
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

  Future<void> loadAreas() async {
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

  Future<bool> onSubmit({bool create = false}) async {
    emit(PermitsLoading());
    try {
      if (!formKey.currentState!.validate() || areaIndex == null) {
        emit(const PermitsError(
            snackbarMessage: "Please enter the correct information"));
        return false;
      }

      if (create) {
        var result = await _api.getPermitsApi().permitsPost(
              createPermitDto: CreatePermitDto(
                name: permitNameController.text,
                capacity: int.parse(permitCapacityController.text),
                price: double.parse(permitPriceController.text),
                areaId: areas[areaIndex!].id!,
                days: _permitDays.values.toList().reversed.toList(),
              ),
            );

        if (result.data == null) {
          emit(PermitsError(snackbarMessage: result.statusMessage));
        }

        if (result.data!.responseCode == ResponseCode.Success) {
          emit(const PermitsLoaded(
              snackbarMessage: "Permit created successfully"));
          permitsDataSource.refreshDatasource();
          permitsDataSource.deselectAll();
          return true;
        } else {
          emit(PermitsError(snackbarMessage: result.data!.message.toString()));
          return false;
        }
      } else {
        var result = await _api.getPermitsApi().permitsIdPost(
              id: permit!.id!,
              createPermitDto: CreatePermitDto(
                name: permitNameController.text,
                capacity: int.parse(permitCapacityController.text),
                price: double.parse(permitPriceController.text),
                areaId: areas[areaIndex!].id!,
                days: _permitDays.values.toList().reversed.toList(),
              ),
            );

        if (result.data == null) {
          emit(PermitsError(snackbarMessage: result.statusMessage));
        }

        if (result.data!.responseCode == ResponseCode.Success) {
          emit(const PermitsLoaded(
              snackbarMessage: "Permit updated successfully"));
          permitsDataSource.refreshDatasource();
          permitsDataSource.deselectAll();
          return true;
        } else {
          emit(PermitsError(snackbarMessage: result.data!.message.toString()));
          return false;
        }
      }
    } catch (e) {
      emit(PermitsError(snackbarMessage: e.toString()));
      return false;
    }
  }

  String attendingDaysString(List<bool> bools) {
    List<String> result = [];
    for (int i = 0; i < 5; i++) {
      if (bools[i]) {
        result.add(permitDays[i]);
      }
    }

    return result.join(',');
  }
}
