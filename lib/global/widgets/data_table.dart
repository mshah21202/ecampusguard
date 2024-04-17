import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppDataTable extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.dataSource,
    required this.columns,
    required this.rowsPerPage,
    required this.onPageChanged,
    this.sortColumnIndex,
    this.sortAscending,
  });

  final AsyncDataTableSource dataSource;
  final List<DataColumn> columns;
  final int rowsPerPage;
  final int? sortColumnIndex;
  final bool? sortAscending;
  final void Function(int) onPageChanged;

  @override
  State<AppDataTable> createState() => _AppDataTableState();
}

class _AppDataTableState extends State<AppDataTable> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.background,
      ),
      child: AsyncPaginatedDataTable2(
        onSelectAll: (value) {
          (value ?? false)
              ? widget.dataSource.selectAll()
              : widget.dataSource.deselectAll();
        },
        sortArrowAlwaysVisible: true,
        sortColumnIndex: widget.sortColumnIndex,
        sortAscending: widget.sortAscending ?? true,
        dataRowHeight: height * 0.15,
        checkboxAlignment: Alignment.center,
        checkboxHorizontalMargin: 0,
        border: TableBorder(
          horizontalInside: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
          verticalInside: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        headingRowDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
        ),
        headingTextStyle: TextStyle(
          color: theme.colorScheme.onBackground,
        ),
        rowsPerPage: widget.rowsPerPage,
        onPageChanged: widget.onPageChanged,
        wrapInCard: false,
        columns: widget.columns,
        source: widget.dataSource,
      ),
    );
  }
}
