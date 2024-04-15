import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/application_status_chip.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

class PermitApplicationsDataSource extends AsyncDataTableSource {
  PermitApplicationsDataSource.fromApi({
    required this.fetchFunction,
  });

  final Future<List<PermitApplicationInfoDto>> Function(
      int startIndex, int count) fetchFunction;

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<PermitApplicationInfoDto> applications =
        await fetchFunction(startIndex, count);

    List<DataRow> rows = applications
        .map(
          (a) => DataRow2(
            onSelectChanged: (value) {},
            cells: [
              DataCell(
                Text(a.studentId.toString()),
              ),
              DataCell(
                Text(a.studentName ?? ""),
              ),
              DataCell(
                Text(a.academicYear ?? ""),
              ),
              DataCell(
                Text(a.permitName ?? ""),
              ),
              DataCell(
                PermitApplicationStatusChip(
                  status: (a.status ??
                      PermitApplicationStatus.unknownDefaultOpenApi),
                ),
              ),
              DataCell(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye),
                      label: const Text("Review"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
          ),
        )
        .toList();

    return AsyncRowsResponse(rows.length, rows);
  }
}
