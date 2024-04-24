import 'package:bloc/bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/services/data_sources.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'areas_state.dart';

class AreasCubit extends Cubit<AreasState> {
  AreasCubit() : super(AreasInitial()) {
    areasDataSource = AreasDataSource.fromApi(
      fetchFunction: getAreas,
      cubit: this,
    );
  }

  late AreasDataSource areasDataSource;
  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  List<AreaDto> areas = [];
  List<AreaDto> selectedAreas = [];
  AreaDto? area;
  int pageNumber = 0;
  int pageSize = 10;
  final TextEditingController areaNameController = TextEditingController();
  final TextEditingController areaGateController = TextEditingController();
  final TextEditingController areaCapacityController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void selectedRowsListener() {
    selectedAreas = areasDataSource.selectionState == SelectionState.include
        ? areasDataSource.selectionRowKeys
            .map((key) => areas[(key as ValueKey<int>).value])
            .toList()
        : areas.indexed
            .where((element) => !areasDataSource.selectionRowKeys
                .contains(ValueKey(element.$1)))
            .map((e) => e.$2)
            .toList();

    if (areasDataSource.selectionState == SelectionState.none) {
      selectedAreas = [];
    }

    emit(AreasRowSelectionUpdate(selectedAreas: selectedAreas));
  }

  Future<List<AreaDto>> getAreas(int startIndex, int count) async {
    emit(AreasLoading());
    try {
      var result = await _api.getAreaApi().areaGet(
            pageNumber: startIndex ~/ count,
            pageSize: pageSize,
          );

      if (result.data != null) {
        areas = result.data!;
        emit(AreasLoaded(areas: areas));
        return areas;
      } else {
        emit(AreasError(snackbarMessage: result.statusMessage));
      }
    } catch (e) {
      emit(AreasError(snackbarMessage: e.toString()));
    }

    return [];
  }

  void getArea(int id) async {
    emit(AreasLoading());
    try {
      var result = await _api.getAreaApi().areaIdGet(id: id);

      if (result.data == null) {
        emit(AreasError(snackbarMessage: result.statusMessage));
        return;
      }

      area = result.data!;
      populateFields();
      emit(AreasLoaded(area: area));
    } catch (e) {
      emit(AreasError(snackbarMessage: e.toString()));
    }
  }

  void populateFields() {
    if (area != null) {
      areaNameController.text = area!.name!;
      areaGateController.text = area!.gate!;
      areaCapacityController.text = area!.capacity!.toString();
    } else {
      areaNameController.clear();
      areaCapacityController.clear();
      areaGateController.clear();
    }
  }

  Future<void> onSubmit({bool create = false}) async {
    emit(AreasLoading());
    if (!formKey.currentState!.validate()) {
      emit(
        const AreasError(
            snackbarMessage: "Please enter the correct information"),
      );
      return;
    }

    try {
      if (create) {
        // If creating new area
        var result = await _api.getAreaApi().areaPost(
              areaDto: AreaDto(
                name: areaNameController.text,
                gate: areaGateController.text,
                capacity: int.parse(areaCapacityController.text),
              ),
            );

        if (result.data == null) {
          emit(AreasError(snackbarMessage: result.statusMessage));
          return;
        }

        emit(AreasLoaded(
          snackbarMessage: result.data?.message.toString(),
        ));
      } else {
        // If updating area
        var result = await _api.getAreaApi().areaIdPost(
              id: area!.id!,
              areaDto: AreaDto(
                name: areaNameController.text,
                gate: areaGateController.text,
                capacity: int.parse(areaCapacityController.text),
              ),
            );

        if (result.data == null) {
          emit(AreasError(snackbarMessage: result.statusMessage));
          return;
        }

        emit(AreasLoaded(
          snackbarMessage: result.data?.message.toString(),
        ));
      }
    } catch (e) {
      emit(AreasError(snackbarMessage: e.toString()));
    }
  }

  void onDelete({int? index}) async {
    emit(AreasLoading());
    try {
      if (index == null) {
        for (var area in selectedAreas) {
          var result = await _api.getAreaApi().areaIdDelete(id: area.id!);

          if (result.data == null) {
            emit(AreasError(snackbarMessage: result.statusMessage));
            return;
          }
        }
      } else {
        var result = await _api.getAreaApi().areaIdDelete(id: areas[index].id!);

        if (result.data == null) {
          emit(AreasError(snackbarMessage: result.statusMessage));
          return;
        }
      }

      areasDataSource.refreshDatasource();
      areasDataSource.deselectAll();
      emit(const AreasLoaded(snackbarMessage: "Sucessfully deleted area(s)"));
    } catch (e) {
      emit(AreasError(snackbarMessage: e.toString()));
    }
  }

  void onPageChanged(int page) {
    pageNumber = page;
    areasDataSource.refreshDatasource();
  }

  void onRowTap(int index) {
    emit(AreasOnRowTap(area: areas[index]));
  }
}
