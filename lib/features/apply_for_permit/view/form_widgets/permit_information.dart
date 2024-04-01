import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/days_indicator.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:flutter/material.dart';

class PermitInformationForm extends StatelessWidget {
  const PermitInformationForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FormFields(
            title: "Permit Information",
            gap: 25,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Permit Type")),
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
                              "Engineering Gate",
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
                              "40 JOD",
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
                      const DaysIndicator(
                        days: [true, false, true, false, true],
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
                value: false,
                onChanged: (newVal) {},
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
  }
}
