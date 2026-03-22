import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';

class RateBusScreen extends StatefulWidget {
  final String busId;
  final String busName;

  const RateBusScreen({
    super.key,
    required this.busId,
    required this.busName,
  });

  @override
  State<RateBusScreen> createState() => _RateBusScreenState();
}

class _RateBusScreenState extends State<RateBusScreen> {
  final _supabase = Supabase.instance.client;
  final _reviewController = TextEditingController();
  
  double _overallRating = 3;
  double _cleanlinessRating = 3;
  double _comfortRating = 3;
  double _punctualityRating = 3;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    try {
      await _supabase.from('bus_ratings').insert({
        'bus_id': widget.busId,
        'bus_name': widget.busName,
        'rating': _overallRating.toInt(),
        'review': _reviewController.text,
        'cleanliness_rating': _cleanlinessRating.toInt(),
        'comfort_rating': _comfortRating.toInt(),
        'punctuality_rating': _punctualityRating.toInt(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rate Bus'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bus Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.directions_bus, color: Colors.white, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.busName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'How was your experience?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Overall Rating
            Text(
              'Overall Rating',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(
                    _overallRating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primary,
                      fontSize: 48,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _overallRating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: AppTheme.warning,
                        ),
                        onPressed: () {
                          setState(() => _overallRating = index + 1.0);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Detailed Ratings
            _buildRatingSlider(
              'Cleanliness',
              Icons.cleaning_services,
              _cleanlinessRating,
              (value) => setState(() => _cleanlinessRating = value),
            ),
            const SizedBox(height: 20),
            _buildRatingSlider(
              'Comfort',
              Icons.airline_seat_recline_normal,
              _comfortRating,
              (value) => setState(() => _comfortRating = value),
            ),
            const SizedBox(height: 20),
            _buildRatingSlider(
              'Punctuality',
              Icons.access_time,
              _punctualityRating,
              (value) => setState(() => _punctualityRating = value),
            ),
            
            const SizedBox(height: 32),
            
            // Review
            Text(
              'Write a Review (Optional)',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Share your experience...',
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRating,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.send),
                          SizedBox(width: 8),
                          Text('Submit Rating'),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
    String label,
    IconData icon,
    double value,
    ValueChanged<double> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
