import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

Widget buildInfoBox({required String title, required String content, required BuildContext context}) { // Renamed function to avoid naming conflict
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
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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

Widget buildVehicleInfoBox({required VehicleDto? vehicle, required BuildContext context}) { // Renamed function to avoid naming conflict
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
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 30,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildVehicleDetail('Plate Number', vehicle.plateNumber, context), // Added missing context parameter
                  buildVehicleDetail('Nationality', vehicle.nationality, context), // Added missing context parameter
                  buildVehicleDetail('Make', vehicle.make, context), // Added missing context parameter
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildVehicleDetail('Model', vehicle.model, context), // Added missing context parameter
                  buildVehicleDetail('Year', vehicle.year.toString(), context), // Added missing context parameter
                  buildVehicleDetail('Color', vehicle.color, context), // Added missing context parameter
                ],
              ),
            ),
          ]
        ),
      ],
    ),
  );
}

Widget buildVehicleDetail(String title, String content, BuildContext context) { // Renamed function to avoid naming conflict
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
