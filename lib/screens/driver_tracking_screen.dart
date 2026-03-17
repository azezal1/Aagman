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
            Text(
              'Driver Mode',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 18,
              ),
            ),
            Text(
              widget.driverId,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Enhanced Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _isTracking
                        ? AppTheme.accent.withOpacity(0.12)
                        : AppTheme.textSecondary.withOpacity(0.05),
                    _isTracking
                        ? AppTheme.accent.withOpacity(0.05)
                        : AppTheme.textSecondary.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isTracking ? AppTheme.accent.withOpacity(0.3) : AppTheme.border,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Animated Icon Container
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: _isTracking
                          ? AppTheme.accent.withOpacity(0.15)
                          : AppTheme.textSecondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                      boxShadow: _isTracking
                          ? [
                              BoxShadow(
                                color: AppTheme.accent.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Icon(
                      _isTracking ? Icons.gps_fixed : Icons.gps_off,
                      size: 44,
                      color: _isTracking ? AppTheme.accent : AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _status,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: _isTracking ? AppTheme.accent : AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isTracking
                        ? 'Passengers can see your location'
                        : 'Ready to start tracking',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Cards with better styling
            _buildInfoCard(
              'Bus Number',
              'Bus ${widget.busId}',
              Icons.directions_bus_rounded,
              AppTheme.accent,
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Updates Sent',
              _updateCount.toString(),
              Icons.cloud_upload_outlined,
              AppTheme.accent,
            ),
            
            if (_currentPosition != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                'Current Speed',
                '${(_currentPosition!.speed * 3.6).toStringAsFixed(1)} km/h',
                Icons.speed_rounded,
                AppTheme.accent,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                'Location',
                '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                Icons.location_on_rounded,
                AppTheme.accent,
              ),
            ],
            
            const Spacer(),
            
            // Enhanced Control Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isTracking ? _stopTracking : _startTracking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTracking
                      ? AppTheme.statusAmber
                      : AppTheme.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isTracking ? Icons.stop_circle_outlined : Icons.play_circle_outline,
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
            
            // Info Text with icon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _isTracking
                      ? 'Location shared every 30 seconds'
                      : 'Tap to start sharing your location',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
