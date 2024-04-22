import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';

  class PreviousPermits extends StatelessWidget {
  const PreviousPermits({super.key, required this.permits});

  final List<PermitDto> permits;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Previous Permits',
            style: TextStyle(
              fontSize: 24,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Builder(builder: (context) {

          //Student has no previous permit
          if (permits.isEmpty) {
            return const Center(
              child: Text(
                "You have no previous permits.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            );
          }

          //Student has permits
          else {
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                itemCount: permits.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final permit = permits[index];
                  return ListTile(
                    title: Text(permit.name ?? ""),
                    subtitle: Text(
                        'Valid for ${permit.days} days - \$${permit.price!.toStringAsFixed(2)}'),
                    trailing:
                        Text('Occupied: ${permit.occupied}/${permit.capacity}'),
                  );
                },
              ),
            );
          }
        })
      ],
    );
  }
}
