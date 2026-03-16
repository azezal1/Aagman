import 'package:flutter/material.dart';
import '../config/theme.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? _selectedIssue;
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issues = [
      'Where is my bus?',
      'Bus delayed',
      'Wrong route information',
      'App not working',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Feedback',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help you?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select an issue or write to us',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            
            // Issue Selection
            Text(
              'Select Issue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            ...issues.map((issue) => _buildIssueOption(issue, context)),
            
            const SizedBox(height: 24),
            
            // Message Input
            Text(
              'Describe your issue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tell us more about your issue...',
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Submit feedback to Supabase
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback submitted successfully'),
                      backgroundColor: AppTheme.accent,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueOption(String issue, BuildContext context) {
    final isSelected = _selectedIssue == issue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIssue = issue;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withOpacity(0.1) : AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              issue,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected ? AppTheme.accent : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
