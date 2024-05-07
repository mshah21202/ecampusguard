import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../areas.dart';

class AreaDetailsView extends StatefulWidget {
  const AreaDetailsView({
    Key? key,
    this.areaId,
  })  : _isCreating = areaId == null,
        super(key: key);

  final int? areaId;
  final bool _isCreating;

  @override
  State<AreaDetailsView> createState() => _AreaDetailsViewState();
}

class _AreaDetailsViewState extends State<AreaDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AreasCubit>();
    if (widget.areaId != null) {
      cubit.getArea(widget.areaId!);
    } else {
      cubit.area = null;
    }
    cubit.populateFields();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AreasCubit>();
    var theme = Theme.of(context);
    return Scaffold(
      drawer: const AdminAppDrawer(),
      appBar: appBar(),
      body: BlocBuilder<AreasCubit, AreasState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.25,
                  vertical: ResponsiveWidget.smallPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${widget._isCreating ? "Create" : "Edit"} Area",
                      style: theme.textTheme.headlineLarge!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    Form(
                      key: cubit.formKey,
                      child: FormFields(
                        title: "Area Information",
                        gap: 25,
                        singleColumn: true,
                        children: [
                          TextFormField(
                            controller: cubit.areaNameController,
                            decoration: const InputDecoration(
                              labelText: "Name",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }

                              return null;
                            },
                          ),
                          TextFormField(
                            controller: cubit.areaGateController,
                            decoration: const InputDecoration(
                              labelText: "Gate",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }

                              return null;
                            },
                          ),
                          TextFormField(
                            controller: cubit.areaCapacityController,
                            decoration: const InputDecoration(
                              labelText: "Capacity",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }

                              if (int.tryParse(value) == null ||
                                  int.tryParse(value)! <= 0) {
                                return "Please enter a valid number (1-9999)";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            cubit.onSubmit(create: widget._isCreating).then(
                              (value) {
                                context.pop();
                                cubit.areasDataSource.refreshDatasource();
                              },
                            );
                          },
                          icon: const Icon(Icons.check),
                          label: const Text("Save Area"),
                        ),
                        SizedBox(
                          width: ResponsiveWidget.smallPadding(context),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(Icons.close),
                          label: const Text("Cancel"),
                        ),
                      ],
                    )
                  ].addElementBetweenElements(
                    SizedBox(
                      height: ResponsiveWidget.smallPadding(context),
                    ),
                  ),
                ),
              ),
              FullScreenLoadingIndicator(visible: state is AreasLoading)
            ],
          );
        },
      ),
    );
  }
}
