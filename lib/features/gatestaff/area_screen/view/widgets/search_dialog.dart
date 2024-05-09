import 'package:ecampusguard/features/admin/user_permits/view/widgets/user_permit_status_chip.dart';
import 'package:ecampusguard/features/gatestaff/area_screen/cubit/area_screen_cubit.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({super.key});

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<AreaScreenCubit, AreaScreenState>(
      builder: (context, state) {
        var cubit = context.read<AreaScreenCubit>();
        return Dialog(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width *
                (ResponsiveWidget.isLargeScreen(context) ? 0.3 : 0.8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Search",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          labelText: "Student ID",
                        ),
                      ),
                      TextFormField(
                        controller: _plateNumberController,
                        decoration: const InputDecoration(
                          labelText: "Plate Number",
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.icon(
                          onPressed: () {
                            cubit.searchUserPermit(
                              plateNumber:
                                  _plateNumberController.text.isNotEmpty
                                      ? _plateNumberController.text
                                      : null,
                              studentId: _studentIdController.text.isNotEmpty
                                  ? _studentIdController.text
                                  : null,
                            );
                          },
                          icon: const Icon(Icons.search),
                          label: const Text("Search"),
                        ),
                      ),
                      if (state is SearchDialogLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: cubit.searchResult.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                cubit.searchResult[index].vehicle!.plateNumber,
                              ),
                              leading: UserPermitStatusChip(
                                status: cubit.searchResult[index].status!,
                              ),
                            );
                          },
                        ),
                    ].addElementBetweenElements(
                      const SizedBox(
                        height: 16,
                      ),
                    ),
                  ),
                ].addElementBetweenElements(
                  const SizedBox(
                    height: 18,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
