import 'package:data_table_2/data_table_2.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/router/routes.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/app_logo.dart';
import 'package:ecampusguard/global/widgets/data_table.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguard/global/widgets/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../areas.dart';

class AreasListView extends StatefulWidget {
  const AreasListView({
    Key? key,
  }) : super(key: key);

  @override
  State<AreasListView> createState() => _AreasListViewState();
}

class _AreasListViewState extends State<AreasListView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AreasCubit>();

    cubit.areasDataSource.addListener(cubit.selectedRowsListener);
  }

  // @override
  // void dispose() {
  //   if (mounted) {
  //     final cubit = context.read<AreasCubit>();
  //     cubit.areasDataSource.removeListener(cubit.selectedRowsListener);
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AreasCubit>();
    var theme = Theme.of(context);
    return BlocListener<AreasCubit, AreasState>(
      listener: (context, state) {
        if (state is AreasOnRowTap) {
          context.go("$adminHomeRoute/$adminAreasRoute/${state.area!.id}");
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
      listenWhen: (previous, current) => true,
      child: Scaffold(
        drawer: const AdminAppDrawer(),
        appBar: appBar,
        body: BlocBuilder<AreasCubit, AreasState>(builder: (context, state) {
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
                            "Areas",
                            style: theme.textTheme.headlineSmall,
                          ),
                          BlocBuilder<AreasCubit, AreasState>(
                            buildWhen: (previous, current) {
                              return current is AreasRowSelectionUpdate;
                            },
                            builder: (context, state) {
                              return Row(
                                children: [
                                  Visibility(
                                    visible:
                                        cubit.areasDataSource.selectedRowCount >
                                            0,
                                    child: FilledButton.tonalIcon(
                                      onPressed: () {
                                        cubit.onDelete();
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: Text(
                                        "Delete Area${cubit.areasDataSource.selectedRowCount > 1 ? "s" : ""}",
                                      ),
                                    ),
                                  ),
                                  FilledButton.icon(
                                    label: const Text("Create Area"),
                                    onPressed: () {
                                      context.go(
                                        "$adminHomeRoute/$adminAreasRoute/$adminCreateAreaRoute",
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
                        dataSource: cubit.areasDataSource,
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
                            label: Text("Capacity"),
                          ),
                          DataColumn2(
                            size: ColumnSize.L,
                            label: Text("Gate"),
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
              FullScreenLoadingIndicator(visible: state is AreasLoading)
            ],
          );
        }),
      ),
    );
  }
}
