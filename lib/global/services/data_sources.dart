import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/areas/cubit/areas_cubit.dart';
import 'package:ecampusguard/features/admin/permit_applications/cubit/permit_applications_cubit.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguard/features/admin/permits/permits.dart';
import 'package:ecampusguard/features/admin/user_permits/cubit/user_permits_cubit.dart';
import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/user_permit_applications/user_permit_applications.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/admin/update_request/cubit/update_request_cubit.dart';
import '../../features/admin/update_request/view/widgets/update_request_chip.dart';

class UpdateRequestDataSource extends AsyncDataTableSource {
  UpdateRequestDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<UpdateRequestDto>> Function(int startIndex, int count) fetchFunction;
  final UpdateRequestCubit cubit;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<UpdateRequestDto> updateRequests = await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      updateRequests.length,
      (index) {
        var request = updateRequests[index];
        var rowKey = ValueKey(index);
        return DataRow2(
          key: rowKey,
          onTap: () {
            cubit.onRowTap(index); 
          },
          cells: [
            DataCell(Text(request.userPermit?.user?.name ?? 'N/A')),
            DataCell(Text(request.updatedVehicle?.plateNumber ?? 'N/A')),
            DataCell(Text(request.phoneNumber)),
            DataCell(
              UpdateRequestStatusChip(
                status: request.status ?? UpdateRequestStatus.unknownDefaultOpenApi, 
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(cubit.totalRows, rows); 
  }
}

class PermitApplicationsDataSource extends AsyncDataTableSource {
  PermitApplicationsDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<PermitApplicationInfoDto>> Function(
      int startIndex, int count) fetchFunction;

  final PermitApplicationsCubit cubit;

  List<String> academicYears = [
    "First Year",
    "Second Year",
    "Third Year",
    "Forth+ Year",
  ];

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<PermitApplicationInfoDto> applications =
        await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      applications.length,
      (index) {
        var rowKey = ValueKey(index);
        return DataRow2(
          key: rowKey,
          onTap: () {
            cubit.onRowTap(index);
          },
          cells: [
            DataCell(
              Text(applications[index].studentId.toString()),
            ),
            DataCell(
              Text(applications[index].studentName ?? ""),
            ),
            DataCell(
              Text(academicYears[applications[index].academicYear!.index]),
            ),
            DataCell(
              Text(applications[index].permitName ?? ""),
            ),
            DataCell(
              PermitApplicationStatusChip(
                status: (applications[index].status ??
                    PermitApplicationStatus.unknownDefaultOpenApi),
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(cubit.totalRows, rows);
  }
}

class UserPermitApplicationsDataSource extends AsyncDataTableSource {
  UserPermitApplicationsDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<PermitApplicationInfoDto>> Function(
      int startIndex, int count) fetchFunction;

  final UserPermitApplicationsCubit cubit;

  List<String> academicYears = [
    "First Year",
    "Second Year",
    "Third Year",
    "Forth+ Year",
  ];

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<PermitApplicationInfoDto> applications =
        await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      applications.length,
      (index) {
        return DataRow2(
          key: ValueKey(index),
          onTap: () {
            cubit.onRowTap(index);
          },
          cells: [
            DataCell(
              Text(applications[index].studentId.toString()),
            ),
            DataCell(
              Text(applications[index].studentName ?? ""),
            ),
            DataCell(
              Text(academicYears[applications[index].academicYear!.index]),
            ),
            DataCell(
              Text(applications[index].permitName ?? ""),
            ),
            DataCell(
              PermitApplicationStatusChip(
                status: (applications[index].status ??
                    PermitApplicationStatus.unknownDefaultOpenApi),
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(cubit.totalRows, rows);
  }
}

class AreasDataSource extends AsyncDataTableSource {
  AreasDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<AreaDto>> Function(int startIndex, int count) fetchFunction;

  final AreasCubit cubit;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<AreaDto> areas = await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      areas.length,
      (index) {
        var rowKey = ValueKey(index);
        return DataRow2(
          key: rowKey,
          onSelectChanged: (value) {
            setRowSelection(rowKey, value ?? false);
          },
          selected: selectionState == SelectionState.include
              ? selectionRowKeys.contains(rowKey)
              : !selectionRowKeys.contains(rowKey),
          onTap: () {
            cubit.onRowTap(index);
          },
          cells: [
            DataCell(
              Text(areas[index].id.toString()),
            ),
            DataCell(
              Text(areas[index].name!),
            ),
            DataCell(
              Text(areas[index].capacity.toString()),
            ),
            DataCell(
              Text(areas[index].gate!),
            ),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cubit.onDelete(index: index);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(rows.length, rows);
  }
}

class PermitsDataSource extends AsyncDataTableSource {
  PermitsDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<PermitDto>> Function(int startIndex, int count)
      fetchFunction;

  final PermitsCubit cubit;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<PermitDto> permits = await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      permits.length,
      (index) {
        var rowKey = ValueKey(index);
        return DataRow2(
          key: rowKey,
          onSelectChanged: (value) {
            setRowSelection(rowKey, value ?? false);
          },
          selected: selectionState == SelectionState.include
              ? selectionRowKeys.contains(rowKey)
              : !selectionRowKeys.contains(rowKey),
          onTap: () {
            cubit.onRowTap(index);
          },
          cells: [
            DataCell(
              Text(permits[index].id.toString()),
            ),
            DataCell(
              Text(permits[index].name!),
            ),
            DataCell(
              Text(permits[index].area!.name!.toString()),
            ),
            DataCell(
              Text(cubit.attendingDaysString(permits[index].days!)),
            ),
            DataCell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cubit.onDelete(index: index);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(rows.length, rows);
  }
}

class UserPermitsDataSource extends AsyncDataTableSource {
  UserPermitsDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<UserPermitDto>> Function(int startIndex, int count)
      fetchFunction;

  final UserPermitsCubit cubit;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<UserPermitDto> userPermits = await fetchFunction(startIndex, count);

    List<DataRow> rows = List.generate(
      userPermits.length,
      (index) {
        var rowKey = ValueKey(index);
        return DataRow2(
          key: rowKey,
          onSelectChanged: (value) {
            setRowSelection(rowKey, value ?? false);
          },
          selected: selectionState == SelectionState.include
              ? selectionRowKeys.contains(rowKey)
              : !selectionRowKeys.contains(rowKey),
          onTap: () {
            cubit.onRowTap(index);
          },
          cells: [
            DataCell(
              Text(userPermits[index].user!.studentId!),
            ),
            DataCell(
              Text(userPermits[index].user!.name!),
            ),
            DataCell(
              Text(userPermits[index].vehicle!.plateNumber),
            ),
            DataCell(
              Text(DateFormat("dd/MM/y").format(userPermits[index].expiry!)),
            ),
            DataCell(
              Text(userPermits[index].permit!.name!),
            ),
            DataCell(
              UserPermitStatusChip(
                status: userPermits[index].status!,
              ),
            ),
          ],
        );
      },
    );

    return AsyncRowsResponse(rows.length, rows);
  }
}
