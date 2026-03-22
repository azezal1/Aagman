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
  String _status = 'Ready';
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
      setState(() => _status = 'Location services disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _status = 'Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _status = 'Location permission permanently denied');
      return;
    }

    setState(() => _status = 'Ready');
  }

  Future<void> _startTracking() async {
    setState(() {
      _isTracking = true;
      _status = 'Starting...';
      _updateCount = 0;
    });

    await _updateLocation();
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
        _status = 'Active';
      });

      await _sendLocationToSupabase(position);
    } catch (e) {
      setState(() => _status = 'Error: ${e.toString()}');
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
    } catch (e) {
      setState(() => _status = 'Upload error');
    }
  }

  void _stopTracking() {
    _locationTimer?.cancel();
    setState(() {
      _isTracking = false;
      _status = 'Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Driver Mode'),
            Text(
              widget.driverId,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _isTracking ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isTracking ? AppTheme.primary : AppTheme.border,
                  width: 1,
                ),
                boxShadow: _isTracking
                    ? [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isTracking
                          ? Colors.white.withOpacity(0.2)
                          : AppTheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
                      size: 40,
                      color: _isTracking ? Colors.white : AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _status,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _isTracking ? Colors.white : AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isTracking
                        ? 'Passengers can see your location'
                        : 'Tap below to start tracking',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _isTracking
                          ? Colors.white.withOpacity(0.9)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Bus',
                    'Bus ${widget.busId}',
                    Icons.directions_bus,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Updates',
                    _updateCount.toString(),
                    Icons.cloud_upload,
                  ),
                ),
              ],
            ),
            
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Speed',
                      '${(_currentPosition!.speed * 3.6).toStringAsFixed(1)} km/h',
                      Icons.speed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Accuracy',
                      '${_currentPosition!.accuracy.toStringAsFixed(0)}m',
                      Icons.my_location,
                    ),
                  ),
                ],
              ),
            ],
            
            const Spacer(),
            
            // Control Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isTracking ? _stopTracking : _startTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTracking ? AppTheme.error : AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isTracking ? Icons.stop_circle : Icons.play_circle_filled,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _isTracking ? 'Stop Tracking' : 'Start Tracking',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Info Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  _isTracking
                      ? 'Location updates every 30 seconds'
                      : 'GPS tracking will start immediately',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(height: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
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
          'Passengers will no longer see your location. Are you sure?',
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
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.error,
            ),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
