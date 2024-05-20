import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

Widget buildInfoBox({ required String content, required BuildContext context}) { 
  var theme = Theme.of(context);
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Phone Number',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        SelectableText(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

Widget buildVehicleInfoBox({required VehicleDto? vehicle, required BuildContext context}) { 
  var theme = Theme.of(context);
  if (vehicle == null) return const SizedBox.shrink();
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Details',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildVehicleDetail('Plate Number', vehicle.plateNumber, context), 
                  buildVehicleDetail('Nationality', vehicle.nationality, context), 
                  buildVehicleDetail('Make', vehicle.make, context), 
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildVehicleDetail('Model', vehicle.model, context), 
                  buildVehicleDetail('Year', vehicle.year.toString(), context), 
                  buildVehicleDetail('Color', vehicle.color, context), 
                ],
              ),
            ),
          ]
        ),
      ],
    ),
  );
}

Widget buildVehicleDetail(String title, String content, BuildContext context) { 
  var theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Text(
          '$title: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SelectableText(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
