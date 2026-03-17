import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';

class DriverTrackingScreen extends StatefulWidget {
  final String driverId;
  final String busId;

  const DriverTrackingScreen({
    super.key,
    required this.driverId,
    required this.busId,
  });

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  bool _isTracking = false;
  Timer? _locationTimer;
  Position? _currentPosition;
  int _updateCount = 0;
  String _status = 'Ready to start';
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _stopTracking();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _status = 'Location services disabled';
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _status = 'Location permission denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _status = 'Location permission permanently denied';
      });
      return;
    }

    setState(() {
      _status = 'Ready to start';
    });
  }

  Future<void> _startTracking() async {
    setState(() {
      _isTracking = true;
      _status = 'Starting...';
      _updateCount = 0;
    });

    // Get initial position
    await _updateLocation();

    // Update location every 30 seconds
    _locationTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) => _updateLocation(),
    );
  }

  Future<void> _updateLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _updateCount++;
        _status = 'Tracking active';
      });

      // Send to Supabase
      await _sendLocationToSupabase(position);
    } catch (e) {
      setState(() {
        _status = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _sendLocationToSupabase(Position position) async {
    try {
      await _supabase.from('bus_locations').upsert({
        'bus_id': widget.busId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
        'heading': position.heading.toInt(),
        'timestamp': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      print('Location sent: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error sending location: $e');
      setState(() {
        _status = 'Upload error: ${e.toString()}';
      });
    }
  }

  void _stopTracking() {
    _locationTimer?.cancel();
    setState(() {
      _isTracking = false;
      _status = 'Tracking stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () {
            if (_isTracking) {
              _showStopConfirmation();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          'Driver Mode',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _isTracking
                    ? AppTheme.accent.withOpacity(0.1)
                    : AppTheme.lightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isTracking ? AppTheme.accent : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _isTracking ? Icons.gps_fixed : Icons.gps_off,
                    size: 60,
                    color: _isTracking ? AppTheme.accent : AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _status,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _isTracking ? AppTheme.accent : AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Cards
            _buildInfoCard(
              'Driver ID',
              widget.driverId,
              Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Bus',
              'Bus ${widget.busId}',
              Icons.directions_bus_outlined,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Updates Sent',
              _updateCount.toString(),
              Icons.upload_outlined,
            ),
            
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                'Current Location',
                '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}',
                Icons.location_on_outlined,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Speed',
                '${(_currentPosition!.speed * 3.6).toStringAsFixed(1)} km/h',
                Icons.speed_outlined,
              ),
            ],
            
            const Spacer(),
            
            // Control Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTracking ? _stopTracking : _startTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTracking
                      ? AppTheme.statusAmber
                      : AppTheme.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isTracking ? 'Stop Tracking' : 'Start Tracking',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Text
            Text(
              _isTracking
                  ? 'Location is being shared every 30 seconds'
                  : 'Tap to start sharing your location',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStopConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Tracking?'),
        content: const Text(
          'Are you sure you want to stop tracking? Passengers will no longer see your location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _stopTracking();
              Navigator.pop(context);
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
