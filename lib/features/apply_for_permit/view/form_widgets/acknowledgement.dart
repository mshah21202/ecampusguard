import 'package:ecampusguard/features/apply_for_permit/cubit/apply_for_permit_cubit.dart';
import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Acknowledgement extends StatelessWidget {
  const Acknowledgement({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplyForPermitCubit, ApplyForPermitState>(
        builder: (context, state) {
      var cubit = context.read<ApplyForPermitCubit>();
      return FormFields(
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
      );
    });
  }
}
