import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubit/update_request_cubit.dart';

class UpdateRequestListView extends StatefulWidget {
  const UpdateRequestListView({Key? key}) : super(key: key);

  @override
  _UpdateRequestListViewState createState() => _UpdateRequestListViewState();
}

class _UpdateRequestListViewState extends State<UpdateRequestListView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UpdateRequestCubit>();
    cubit.dataSource.addListener(cubit.selectedRowsListener);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateRequestCubit>();
    var theme = Theme.of(context);

    return BlocListener<UpdateRequestCubit, UpdateRequestState>(
      listener: (context, state) {
        if (state is UpdateRequestAccepted || state is UpdateRequestRejected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.snackBarMessage ?? '')),
          );
        }
      },
      child: Scaffold(
        appBar: appBar(),
        drawer: const AdminAppDrawer(),
        body: BlocBuilder<UpdateRequestCubit, UpdateRequestState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                const BackgroundLogo(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.largePadding(context),
                    vertical: ResponsiveWidget.smallPadding(context),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ResponsiveWidget.smallPadding(context),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Update Requests",
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: AppDataTable(
                          controller: cubit.dataSource,
                          initialFirstRowIndex: cubit.params.currentPage != null
                              ? cubit.params.currentPage! *
                                  (cubit.params.pageSize ?? 10)
                              : null,
                          sortColumnIndex: cubit.sortColumnIndex,
                          // sortAscending: cubit.params.orderByDirection == "ASC",
                          dataSource: cubit.dataSource,
                          onPageChanged: (page) {
                            cubit.setQueryParams(
                              updatedParams: cubit.params.copyWith(
                                currentPage:
                                    page ~/ (cubit.params.pageSize ?? 10),
                                orderBy: '',
                              ),
                              updateDatasource: false,
                            );
                          },
                          rowsPerPage: cubit.params.pageSize ?? 10,
                          columns: [
                            DataColumn2(
                              size: ColumnSize.M,
                              label: const Text("Student ID"),
                              onSort: (columnIndex, ascending) {
                                cubit.setQueryParams(
                                  updatedParams: cubit.params.copyWith(
                                    orderBy: 'studentId',
                                    // orderByDirection: ascending ? "ASC" : "DSC",
                                  ),
                                  sortColumnIndex: columnIndex,
                                );
                              },
                            ),
                            DataColumn2(
                              size: ColumnSize.M,
                              label: const Text("Name"),
                              onSort: (columnIndex, ascending) {
                                cubit.setQueryParams(
                                  updatedParams: cubit.params.copyWith(
                                    orderBy: 'name',
                                    // orderByDirection: ascending ? "ASC" : "DSC",
                                  ),
                                  sortColumnIndex: columnIndex,
                                );
                              },
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: const Text("Phone Number"),
                              onSort: (columnIndex, ascending) {
                                cubit.setQueryParams(
                                  updatedParams: cubit.params.copyWith(
                                    orderBy: 'phoneNumber',
                                    // orderByDirection: ascending ? "ASC" : "DSC",
                                  ),
                                  sortColumnIndex: columnIndex,
                                );
                              },
                            ),
                            DataColumn2(
                              size: ColumnSize.M,
                              label: const Text("Country Code"),
                              onSort: (columnIndex, ascending) {
                                cubit.setQueryParams(
                                  updatedParams: cubit.params.copyWith(
                                    orderBy: 'phoneNumberCountry',
                                    // orderByDirection: ascending ? "ASC" : "DSC",
                                  ),
                                  sortColumnIndex: columnIndex,
                                );
                              },
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: const Text("Status"),
                              onSort: (columnIndex, ascending) {
                                cubit.setQueryParams(
                                  updatedParams: cubit.params.copyWith(
                                    orderBy: 'status',
                                    // orderByDirection: ascending ? "ASC" : "DSC",
                                  ),
                                  sortColumnIndex: columnIndex,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                FullScreenLoadingIndicator(
                  visible: state is UpdateRequestLoading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
