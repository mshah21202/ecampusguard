import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/permit_applications/view/widgets/applications_filter_dialog.dart';
import 'package:ecampusguard/global/helpers/permit_applications_params.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../user_permit_applications.dart';

class UserPermitApplicationsListView extends StatelessWidget {
  const UserPermitApplicationsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserPermitApplicationsCubit,
        UserPermitApplicationsState>(
      listenWhen: (previous, current) {
        if (previous is RowTappedState && current is RowTappedState) {
          return true;
        }

        return previous != current;
      },
      listener: (context, state) {
        if (state is UserPermitApplicationsParamsUpdated) {
          context.go(
              "$homeRoute$userApplicationsRoute${state.params!.toString()}");
        }

        if (state is RowTappedState) {
          context.go("$homeRoute$userApplicationsRoute/${state.id!}");
        }

        if (state.snackbarMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            appSnackBar(state.snackbarMessage!, context),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<UserPermitApplicationsCubit>();
        var theme = Theme.of(context);
        return Scaffold(
          appBar: appBar(),
          drawer: const AppDrawer(),
          body: Stack(
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
                                          studentIdClear: studentId == null,
                                          status: status,
                                          statusClear: status == null,
                                          name: name,
                                          nameClear: name == null,
                                          academicYear: academicYear,
                                          academicYearClear:
                                              academicYear == null,
                                          permitId: permitId,
                                          permitIdClear: permitId == null,
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
                        dataSource: cubit.applicationsDataSource,
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
                        rowsPerPage: cubit.params.pageSize ?? 10,
                        onPageChanged: (page) {
                          cubit.setQueryParams(
                            updatedParams: cubit.params.copyWith(
                              currentPage:
                                  page ~/ (cubit.params.pageSize ?? 10),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              FullScreenLoadingIndicator(
                visible: state is UserPermitApplicationsLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
