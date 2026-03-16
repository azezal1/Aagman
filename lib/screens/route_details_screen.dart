import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/bus.dart';

class RouteDetailsScreen extends StatelessWidget {
  final Bus bus;

  const RouteDetailsScreen({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    // Sample stops - replace with Supabase data
    final stops = [
      {'name': 'Bus Stand', 'time': '08:30 AM', 'status': 'completed'},
      {'name': 'City Center', 'time': '08:45 AM', 'status': 'completed'},
      {'name': 'Hospital', 'time': '09:00 AM', 'status': 'current'},
      {'name': 'College', 'time': '09:20 AM', 'status': 'upcoming'},
      {'name': 'Market', 'time': '09:35 AM', 'status': 'upcoming'},
      {'name': 'Railway Station', 'time': '09:45 AM', 'status': 'upcoming'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bus.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Direct Route',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stops.length,
        itemBuilder: (context, index) {
          final stop = stops[index];
          final isLast = index == stops.length - 1;
          return _buildStopItem(context, stop, isLast);
        },
      ),
    );
  }

  Widget _buildStopItem(BuildContext context, Map<String, dynamic> stop, bool isLast) {
    final status = stop['status'];
    final isCurrent = status == 'current';
    final isCompleted = status == 'completed';
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppTheme.accent
                    : AppTheme.lightGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent ? AppTheme.accent : AppTheme.border,
                  width: isCurrent ? 2.5 : 1,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: AppTheme.surface)
                  : isCurrent
                      ? const Icon(Icons.circle, size: 12, color: AppTheme.surface)
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: isCompleted ? AppTheme.accent : AppTheme.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: isCurrent
                  ? AppTheme.accent.withOpacity(0.1)
                  : AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCurrent ? AppTheme.accent : AppTheme.border,
                width: isCurrent ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    stop['name'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                      color: isCurrent ? AppTheme.accent : AppTheme.textPrimary,
                    ),
                  ),
                ),
                Text(
                  stop['time'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
