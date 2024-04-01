import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:ecampusguard/global/widgets/multi_select_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({
    super.key,
  });

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  @override
  void initState() {
    super.initState();
    var cubit = context.read<ApplyForPermitCubit>();

    cubit.attendingDaysController.addListener(cubit.handleAttendingDays);
    cubit.academicYearController.addListener(() {
      cubit.academicYearController.text = cubit.academicYear != null
          ? cubit.academicYears[cubit.academicYear!]
          : "";
    });

    cubit.loadCountries();
  }

  @override
  void dispose() {
    var cubit = context.read<ApplyForPermitCubit>();

    cubit.attendingDaysController.dispose();
    cubit.academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormFields(
            title: "Personal Details",
            gap: 25,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Student ID")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();
                return MultiSelectDropdownMenu(
                  onSelected: (index) {
                    cubit.onChangedAttendingDay(index ?? 0);
                  },
                  controller: cubit.attendingDaysController,
                  dropdownMenuEntries: cubit.daysNames,
                  selected: cubit.attendingDays,
                );
              }),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();

                return TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Phone Number"),
                    prefixText: cubit.selectedCountry != null &&
                            cubit.selectedCountry!.phoneCode.isNotEmpty
                        ? "${cubit.selectedCountry!.phoneCode[0] != "+" ? "+" : ""}${cubit.selectedCountry!.phoneCode} "
                        : null,
                    prefixIcon: SizedBox(
                        width: 24,
                        child: IconButton(
                          icon: cubit.selectedCountry != null
                              ? Image.network(
                                  "https://flagsapi.com/${cubit.selectedCountry!.isoCode}/flat/64.png")
                              : Icon(Icons.language),
                          onPressed: () {
                            showMenu(
                                context: context,
                                position: RelativeRect.fill,
                                items: cubit.countries
                                    .map((country) => PopupMenuItem(
                                          value: country.isoCode,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: Image.network(
                                                  "https://flagsapi.com/${country.isoCode}/flat/64.png",
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Icon(Icons.language);
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(country.name),
                                            ],
                                          ),
                                          onTap: () {
                                            cubit.setSelectedCountry(country);
                                          },
                                        ))
                                    .toList());
                          },
                        )),
                  ),
                );
              }),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Number of Siblings")),
              ),
              BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
                  builder: (context, state) {
                var cubit = context.read<ApplyForPermitCubit>();

                return DropdownMenu(
                  onSelected: (index) {
                    cubit.academicYear = index;
                    cubit.academicYearController.text =
                        index != null ? cubit.academicYears[index] : "";
                  },
                  controller: cubit.academicYearController,
                  expandedInsets: EdgeInsets.zero,
                  label: const Text("Academic Year"),
                  dropdownMenuEntries: List.generate(
                    cubit.academicYears.length,
                    (index) => DropdownMenuEntry(
                      value: index,
                      label: cubit.academicYears[index],
                    ),
                  ),
                );
              }),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Driving License")),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
