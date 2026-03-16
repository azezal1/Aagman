import 'package:flutter/material.dart';
import '../config/theme.dart';

class PassengerJourneyScreen extends StatelessWidget {
  const PassengerJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Journey',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Journey Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border, width: 0.5),
              ),
              child: Column(
                children: [
                  // Status Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      size: 40,
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Onboard',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Text(
                    'Bus 42A',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Journey Progress
            Text(
              'Journey Progress',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            _buildProgressStep('Bus Stand', '08:30 AM', true, false),
            _buildProgressStep('City Center', '08:45 AM', true, false),
            _buildProgressStep('Hospital', '09:00 AM', true, true),
            _buildProgressStep('College', '09:20 AM', false, false),
            _buildProgressStep('Railway Station', '09:45 AM', false, false),
            
            const SizedBox(height: 24),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Mark as Reached'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStep(String name, String time, bool completed, bool current) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: completed || current
                    ? AppTheme.accent
                    : AppTheme.lightGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: current ? AppTheme.accent : AppTheme.border,
                  width: current ? 2 : 1,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, size: 14, color: AppTheme.surface)
                  : null,
            ),
            if (!current)
              Container(
                width: 2,
                height: 40,
                color: completed ? AppTheme.accent : AppTheme.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: current ? FontWeight.w600 : FontWeight.w400,
                  color: current ? AppTheme.accent : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
