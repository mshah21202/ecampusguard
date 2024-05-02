import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_filter_dialog.dart';
import 'package:ecampusguard/global/helpers/user_permits_params.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../user_permits.dart';

class UserPermitsListView extends StatelessWidget {
  const UserPermitsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserPermitsCubit>();
    var theme = Theme.of(context);
    return BlocListener<UserPermitsCubit, UserPermitsState>(
      listener: (context, state) {
        if (state is UserPermitsParamsUpdate) {
          context.go(
              "$adminHomeRoute/$adminUserPermitsRoute?${state.params!.toString()}");
        }

        if (state is UserPermitsOnRowTap) {
          context.go("$adminHomeRoute/$adminUserPermitsRoute/${state.id!}");
        }
      },
      child: Scaffold(
        appBar: appBar,
        drawer: const AdminAppDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const BackgroundLogo(),
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
                          "User Permits",
                          style: theme.textTheme.headlineSmall,
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return UserPermitFilterDialog(
                                  permits: cubit.permits,
                                  params: cubit.params,
                                  onSave: (studentId, plateNumber, status,
                                      permitId) {
                                    cubit.setQueryParams(
                                      params: UserPermitsParams(
                                        pageSize: cubit.params.pageSize,
                                        currentPage: cubit.params.currentPage,
                                        plateNumber: plateNumber,
                                        studentId: studentId,
                                        permitId: permitId,
                                        status: status,
                                        orderBy: cubit.params.orderBy,
                                        orderByDirection:
                                            cubit.params.orderByDirection,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.filter_alt,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: AppDataTable(
                      dataSource: cubit.userPermitsDataSource,
                      columns: const [
                        DataColumn2(
                          label: Text("Student ID"),
                        ),
                        DataColumn2(
                          label: Text("Student Name"),
                        ),
                        DataColumn2(
                          label: Text("Plate Number"),
                        ),
                        DataColumn2(
                          label: Text("Expiry"),
                        ),
                        DataColumn2(
                          label: Text("Permit"),
                        ),
                        DataColumn2(
                          label: Text("Status"),
                        ),
                      ],
                      rowsPerPage: cubit.params.pageSize ?? 10,
                      onPageChanged: cubit.onPageChanged,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
