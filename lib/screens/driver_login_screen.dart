import 'package:flutter/material.dart';
import '../config/theme.dart';
import 'driver_tracking_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _driverIdController = TextEditingController();
  String? _selectedBus;
  bool _isLoading = false;

  @override
  void dispose() {
    _driverIdController.dispose();
    super.dispose();
  }

  Future<void> _startTracking() async {
    if (_formKey.currentState!.validate() && _selectedBus != null) {
      setState(() => _isLoading = true);
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DriverTrackingScreen(
              driverId: _driverIdController.text,
              busId: _selectedBus!,
            ),
          ),
        );
      }
    } else if (_selectedBus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a bus'),
          backgroundColor: AppTheme.warning,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buses = [
      {'id': '1', 'name': 'Bus 42A'},
      {'id': '2', 'name': 'Express 18'},
      {'id': '3', 'name': 'Bus 7B'},
      {'id': '4', 'name': 'Deluxe 101'},
      {'id': '5', 'name': 'Bus 15'},
      {'id': '6', 'name': 'Super Express 25'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Driver Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Header
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to start tracking and help passengers find your bus',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),
              
              // Driver ID
              Text(
                'Driver ID',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _driverIdController,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Enter your driver ID (e.g., DRV001)',
                  prefixIcon: Icon(Icons.badge, color: AppTheme.primary),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your driver ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Bus Selection
              Text(
                'Select Bus',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBus,
                style: const TextStyle(fontSize: 16, color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Choose your assigned bus',
                  prefixIcon: Icon(Icons.directions_bus, color: AppTheme.primary),
                ),
                items: buses.map((bus) {
                  return DropdownMenuItem(
                    value: bus['id'],
                    child: Text(bus['name']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBus = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: AppTheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location Sharing',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Your location will be shared with passengers while tracking is active. You can stop anytime.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // Start Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startTracking,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.play_arrow, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Start Tracking',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
