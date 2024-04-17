import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/permit_applications/cubit/permit_applications_cubit.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class PermitApplicationsDataSource extends AsyncDataTableSource {
  PermitApplicationsDataSource.fromApi({
    required this.fetchFunction,
    required this.cubit,
  });

  final Future<List<PermitApplicationInfoDto>> Function(
      int startIndex, int count) fetchFunction;

  final PermitApplicationsCubit cubit;

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
              Text(applications[index].studentId.toString()),
            ),
            DataCell(
              Text(applications[index].studentName ?? ""),
            ),
            DataCell(
              Text(applications[index].academicYear ?? ""),
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
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text("Accept"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {},
                          child: const Text("Deny"),
                        ),
                      ),
                    ],
                  )
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
