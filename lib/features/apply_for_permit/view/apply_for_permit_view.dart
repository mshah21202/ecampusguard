import 'package:ecampusguard/features/apply_for_permit/view/form_fields.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../apply_for_permit.dart';

class ApplyForPermitView extends StatelessWidget {
  const ApplyForPermitView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ApplyForPermitCubit>();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("eCampusGuard"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Apply for a permit",
                style: theme.textTheme.headlineLarge
                    ?.copyWith(color: theme.colorScheme.onBackground),
              ),
              Row(
                children: [
                  Expanded(
                    child: FormFields(
                      title: "Personal Details",
                      gap: 25,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Student ID")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Attending Days")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Phone Number")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Number of Siblings")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Academic Year")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Driving License")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormFields(
                      title: "Vehicle Details",
                      gap: 25,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Car Number Plate")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Car Nationality")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Car Make (Company)")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Year of Production")),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Car Model")),
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Color")),
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              label: Text("Valid Car Registration")),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FormFields(
                      title: "Permit Information",
                      gap: 25,
                      children: [
                        TextFormField(
                          decoration:
                              const InputDecoration(label: Text("Permit Type")),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
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
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
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
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                    child: const FormFields(
                      title: 'Acknowledgments',
                      gap: 25,
                      children: [],
                    ),
                  )
                ],
              ),
              // Add buttons here
            ].addElementBetweenElements(const SizedBox(
              height: 32,
            )),
          ),
        ),
      ),
    );
  }
}
