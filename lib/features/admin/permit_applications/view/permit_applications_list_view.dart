import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/applications_filter_dialog.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../permit_applications.dart';

class PermitApplicationsListView extends StatefulWidget {
  const PermitApplicationsListView({
    Key? key,
  }) : super(key: key);

  @override
  State<PermitApplicationsListView> createState() =>
      _PermitApplicationsListViewState();
}

class _PermitApplicationsListViewState
    extends State<PermitApplicationsListView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PermitApplicationsCubit>();
    cubit.applicationsDataSource.addListener(cubit.selectedRowsListener);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitApplicationsCubit>();
    var theme = Theme.of(context);
    return BlocListener<PermitApplicationsCubit, PermitApplicationsState>(
      listener: (context, state) {
        if (state is PermitApplicationsParamsUpdate) {
          String url =
              "$adminHomeRoute/$adminApplicationsRoute?${state.params.toString()}";
          context.go(url);
        }

        if (state is RowTappedState) {
          context.go("$adminHomeRoute/$adminApplicationsRoute/${state.id}");
        }
      },
      listenWhen: (previous, current) {
        return previous != current;
      },
      child: Scaffold(
        appBar: appBar,
        drawer: const AdminAppDrawer(),
        body: BlocBuilder<PermitApplicationsCubit, PermitApplicationsState>(
            builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                left: -150,
                bottom: -150,
                child: Opacity(
                  opacity: 0.2,
                  child: AppLogo(
                    darkMode: theme.colorScheme.brightness == Brightness.dark,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.defaultPadding(context),
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
                            "Applications",
                            style: theme.textTheme.headlineSmall,
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ApplicationFilterDialog(
                                      permits: cubit.permits,
                                      params: cubit.params,
                                      onSave: (studentId, name, academicYear,
                                          permitId, status) {
                                        PermitApplicationsParams params =
                                            cubit.params.copyWith(
                                          studentId: studentId,
                                          status: status,
                                          name: name,
                                          academicYear: academicYear,
                                          permitId: permitId,
                                        );

                                        cubit.setQueryParams(
                                          updatedParams: params,
                                        );
                                      },
                                    );
                                  });
                            },
                            icon: const Icon(Icons.filter_alt),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppDataTable(
                        controller: cubit.controller,
                        initialFirstRowIndex: cubit.params.currentPage != null
                            ? cubit.params.currentPage! *
                                (cubit.params.pageSize ?? 10)
                            : null,
                        sortColumnIndex: cubit.sortColumnIndex,
                        sortAscending: cubit.params.orderByDirection == "ASC",
                        dataSource: cubit.applicationsDataSource,
                        onPageChanged: (page) {
                          PermitApplicationsParams params =
                              PermitApplicationsParams(
                            pageSize: cubit.params.pageSize,
                            currentPage: page ~/ (cubit.params.pageSize ?? 10),
                            studentId: cubit.params.studentId,
                            status: cubit.params.status,
                            name: cubit.params.name,
                            academicYear: cubit.params.academicYear,
                            permitId: cubit.params.permitId,
                            orderBy: cubit.params.orderBy,
                            orderByDirection: cubit.params.orderByDirection,
                          );
                          cubit.setQueryParams(
                            updatedParams: params,
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
                                  orderBy: PermitApplicationOrderBy.StudentId,
                                  orderByDirection: ascending ? "ASC" : "DSC",
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
                                  orderBy: PermitApplicationOrderBy.Name,
                                  orderByDirection: ascending ? "ASC" : "DSC",
                                ),
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: const Text("Academic Year"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                updatedParams: cubit.params.copyWith(
                                  orderBy:
                                      PermitApplicationOrderBy.AcademicYear,
                                  orderByDirection: ascending ? "ASC" : "DSC",
                                ),
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.M,
                            label: const Text("Permit Type"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                updatedParams: cubit.params.copyWith(
                                  orderBy: PermitApplicationOrderBy.PermitType,
                                  orderByDirection: ascending ? "ASC" : "DSC",
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
                                  orderBy: PermitApplicationOrderBy.Status,
                                  orderByDirection: ascending ? "ASC" : "DSC",
                                ),
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              FullScreenLoadingIndicator(
                visible: state is LoadingPermitApplications,
              ),
            ],
          );
        }),
      ),
    );
  }
}
