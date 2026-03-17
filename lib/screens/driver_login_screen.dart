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
      
      // Navigate to tracking screen
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
        const SnackBar(
          content: Text('Please select a bus'),
          backgroundColor: AppTheme.statusAmber,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sample buses - replace with Supabase query
    final buses = [
      {'id': '1', 'name': 'Bus 42A'},
      {'id': '2', 'name': 'Express 18'},
      {'id': '3', 'name': 'Bus 7B'},
      {'id': '4', 'name': 'Deluxe 101'},
      {'id': '5', 'name': 'Bus 15'},
      {'id': '6', 'name': 'Super Express 25'},
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
          'Driver Login',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 50,
                    color: AppTheme.accent,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Driver ID
              Text(
                'Driver ID',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _driverIdController,
                decoration: const InputDecoration(
                  hintText: 'Enter your driver ID',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Bus Selection
              Text(
                'Select Your Bus',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBus,
                decoration: const InputDecoration(
                  hintText: 'Choose bus',
                  prefixIcon: Icon(Icons.directions_bus_outlined),
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
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.accent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your location will be shared with passengers while tracking is active',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Start Tracking Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _startTracking,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.surface,
                            ),
                          ),
                        )
                      : const Text('Start Tracking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
