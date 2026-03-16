import 'package:flutter/material.dart';
import '../config/theme.dart';

class LocationDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final Function(String?) onChanged;

  const LocationDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Sample locations - replace with Supabase data
    final locations = [
      'Bus Stand',
      'Railway Station',
      'City Center',
      'Hospital',
      'College',
      'Market',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: const Icon(Icons.location_on_outlined, 
              color: AppTheme.textSecondary),
          ),
          items: locations.map((location) {
            return DropdownMenuItem(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
