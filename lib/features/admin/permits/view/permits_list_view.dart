import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/extensions/button_extension.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../permits.dart';

class PermitsListView extends StatefulWidget {
  const PermitsListView({
    Key? key,
  }) : super(key: key);

  @override
  State<PermitsListView> createState() => _PermitsListViewState();
}

class _PermitsListViewState extends State<PermitsListView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PermitsCubit>();
    cubit.permitsDataSource.addListener(cubit.selectedRowsListener);
  }

  // @override
  // void dispose() {
  //   final cubit = context.read<PermitsCubit>();
  //   cubit.permitsDataSource.addListener(cubit.selectedRowsListener);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitsCubit>();
    var theme = Theme.of(context);
    return Scaffold(
      drawer: const AdminAppDrawer(),
      appBar: appBar,
      body: BlocConsumer<PermitsCubit, PermitsState>(
        listenWhen: (previous, current) => true,
        listener: (context, state) {
          if (state is PermitsOnRowTap) {
            context.go(
              "$adminHomeRoute/$adminPermitsRoute/${state.permit!.id}",
            );
          }

          if (state.snackbarMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              appSnackBar(
                state.snackbarMessage!,
                context,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
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
                            "Permits",
                            style: theme.textTheme.headlineSmall,
                          ),
                          BlocBuilder<PermitsCubit, PermitsState>(
                            buildWhen: (previous, current) {
                              return current is PermitsRowSelectionUpdate;
                            },
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Visibility(
                                    visible: cubit.permitsDataSource
                                            .selectedRowCount >
                                        0,
                                    child: ErrorFilledButton.tonalIcon(
                                      onPressed: () {
                                        cubit.onDelete();
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: Text(
                                        "Delete Area${cubit.permitsDataSource.selectedRowCount > 1 ? "s" : ""}",
                                      ),
                                    ),
                                  ),
                                  FilledButton.icon(
                                    label: const Text("Create Permit"),
                                    onPressed: () {
                                      context.go(
                                        "$adminHomeRoute/$adminPermitsRoute/$adminCreatePermitRoute",
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ].addElementBetweenElements(
                                  SizedBox(
                                    width:
                                        ResponsiveWidget.smallPadding(context),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppDataTable(
                        dataSource: cubit.permitsDataSource,
                        columns: const [
                          DataColumn2(
                            size: ColumnSize.M,
                            label: Text("ID"),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Text("Name"),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Text("Area"),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Text("Days"),
                          ),
                          DataColumn2(
                            size: ColumnSize.S,
                            label: Text("Delete"),
                          ),
                        ],
                        rowsPerPage: cubit.pageSize,
                        onPageChanged: cubit.onPageChanged,
                      ),
                    )
                  ],
                ),
              ),
              FullScreenLoadingIndicator(
                visible: state is PermitsLoading,
              )
            ],
          );
        },
      ),
    );
  }
}
