import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermitInformationForm extends StatelessWidget {
  const PermitInformationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
        builder: (context, state) {
      var cubit = context.read<ApplyForPermitCubit>();
      return Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FormFields(
              title: "Permit Information",
              gap: 25,
              children: [
                DropdownMenu(
                  expandedInsets: EdgeInsets.zero,
                  label: const Text("Permit Type"),
                  onSelected: (index) {
                    cubit.selectPermitType(cubit.permits![index ?? 0]);
                  },
                  dropdownMenuEntries: List.generate(
                    cubit.permits != null ? cubit.permits!.length : 0,
                    (index) => DropdownMenuEntry(
                        value: index, label: cubit.permits![index].name ?? ""),
                  ),
                ),
                const Center(),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Gate:",
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                cubit.selectedPermit != null &&
                                        cubit.selectedPermit!.area != null
                                    ? cubit.selectedPermit!.area!.gate ?? ""
                                    : "",
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "Fee:",
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                cubit.selectedPermit != null
                                    ? "${cubit.selectedPermit!.price.toString()} JOD"
                                    : "",
                                style: theme.textTheme.headlineSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "Days:",
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        DaysIndicator(
                          days: cubit.selectedPermit != null
                              ? cubit.selectedPermit!.days!.toList()
                              : [false, false, false, false, false],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            width: 32,
          ),
          Expanded(
            child: FormFields(
              title: 'Acknowledgments',
              gap: 15,
              singleColumn: true,
              children: [
                const Text(
                  "By applying to a parking permit you consent to your information being handled and processed in compliance with our Privacy Policy. And you also accept our Terms of Service by checking the box below.\n\nWe reserve the right to withdraw any permit given to any person without cause, without refunding the fee paid.",
                ),
                CheckboxListTile(
                  value: cubit.acknowledged,
                  onChanged: (val) {
                    cubit.setAcknowledged(val ?? false);
                  },
                  title: const Text(
                    "I accept the Terms of Service & Privacy Policy.",
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                )
              ],
            ),
          )
        ],
      );
    });
  }
}
