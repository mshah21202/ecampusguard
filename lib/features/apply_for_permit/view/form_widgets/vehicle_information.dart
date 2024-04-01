import 'package:ecampusguard/features/apply_for_permit/view/form_widgets/form_fields.dart';
import 'package:flutter/material.dart';

class VehicleDetailsForm extends StatelessWidget {
  const VehicleDetailsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FormFields(
            title: "Vehicle Details",
            gap: 25,
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Car Number Plate")),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Car Nationality")),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Car Make (Company)")),
              ),
              TextFormField(
                decoration:
                    const InputDecoration(label: Text("Year of Production")),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Car Model")),
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Color")),
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
    );
  }
}
