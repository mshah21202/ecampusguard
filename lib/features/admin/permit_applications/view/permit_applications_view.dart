import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/applications_filter_dialog.dart';
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

class PermitApplicationsView extends StatefulWidget {
  const PermitApplicationsView({
    Key? key,
  }) : super(key: key);

  @override
  State<PermitApplicationsView> createState() => _PermitApplicationsViewState();
}

class _PermitApplicationsViewState extends State<PermitApplicationsView> {
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
                                        cubit.setQueryParams(
                                          pageSize: cubit.params.pageSize,
                                          currentPage: cubit.params.currentPage,
                                          studentId: studentId,
                                          status: status,
                                          name: name,
                                          academicYear: academicYear,
                                          permitId: permitId,
                                          orderBy: cubit.params.orderBy,
                                          orderByDirection:
                                              cubit.params.orderByDirection,
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
                          cubit.setQueryParams(
                            currentPage: page ~/ (cubit.params.pageSize ?? 10),
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
                                orderBy: PermitApplicationOrderBy.StudentId,
                                orderByDirection: ascending ? "ASC" : "DSC",
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.M,
                            label: const Text("Name"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                orderBy: PermitApplicationOrderBy.Name,
                                orderByDirection: ascending ? "ASC" : "DSC",
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: const Text("Academic Year"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                orderBy: PermitApplicationOrderBy.AcademicYear,
                                orderByDirection: ascending ? "ASC" : "DSC",
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.M,
                            label: const Text("Permit Type"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                orderBy: PermitApplicationOrderBy.PermitType,
                                orderByDirection: ascending ? "ASC" : "DSC",
                                sortColumnIndex: columnIndex,
                              );
                            },
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: const Text("Status"),
                            onSort: (columnIndex, ascending) {
                              cubit.setQueryParams(
                                orderBy: PermitApplicationOrderBy.Status,
                                orderByDirection: ascending ? "ASC" : "DSC",
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
