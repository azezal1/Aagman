import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';
import '../models/bus.dart';
import 'report_delay_screen.dart';
import 'rate_bus_screen.dart';
import 'rate_driver_screen.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Bus bus;

  const LiveTrackingScreen({super.key, required this.bus});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  late AnimationController _pulseController;
  
  LatLng _busLocation = LatLng(23.0225, 72.5714);
  List<Marker> _markers = [];
  bool _isLoading = true;
  String _status = 'Connecting...';
  DateTime? _lastUpdate;
  int _estimatedMinutes = 2; // Mock data

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _initializeTracking();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _initializeTracking() async {
    await _getInitialLocation();
    _subscribeToLocationUpdates();
  }

  Future<void> _getInitialLocation() async {
    try {
      final response = await _supabase
          .from('bus_locations')
          .select()
          .eq('bus_id', widget.bus.id)
          .order('timestamp', ascending: false)
          .limit(1);

      if (response.isNotEmpty) {
        final location = response.first;
        setState(() {
          _busLocation = LatLng(location['latitude'], location['longitude']);
          _lastUpdate = DateTime.parse(location['timestamp']);
          _status = 'LIVE';
          _isLoading = false;
        });
        _updateMarker();
        _moveCamera();
      } else {
        setState(() {
          _status = 'NO DATA';
          _isLoading = false;
        });
        _updateMarker();
      }
    } catch (e) {
      setState(() {
        _status = 'ERROR';
        _isLoading = false;
      });
    }
  }

  void _subscribeToLocationUpdates() {
    _channel = _supabase
        .channel('bus_location_${widget.bus.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bus_locations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'bus_id',
            value: widget.bus.id,
          ),
          callback: (payload) {
            final newLocation = payload.newRecord;
            if (newLocation != null) {
              setState(() {
                _busLocation = LatLng(
                  newLocation['latitude'],
                  newLocation['longitude'],
                );
                _lastUpdate = DateTime.now();
                _status = 'LIVE';
              });
              _updateMarker();
              _moveCamera();
            }
          },
        )
        .subscribe();
  }

  void _updateMarker() {
    setState(() {
      _markers = [
        Marker(
          width: 60,
          height: 60,
          point: _busLocation,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse effect
                  Container(
                    width: 60 * (1 + _pulseController.value * 0.3),
                    height: 60 * (1 + _pulseController.value * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primary.withOpacity(0.3 * (1 - _pulseController.value)),
                    ),
                  ),
                  // Bus marker
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      color: AppTheme.white,
                      size: 24,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ];
    });
  }

  void _moveCamera() {
    _mapController.move(_busLocation, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Stack(
        children: [
          // Full-screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _busLocation,
              initialZoom: 15,
              minZoom: 5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.bus_tracker',
                maxZoom: 19,
              ),
              MarkerLayer(markers: _markers),
            ],
          ),

          // Top Bar - Bold timing
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Back button
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppTheme.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.black),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Bold timing display
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: const BoxDecoration(
                        color: AppTheme.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.bus.name.toUpperCase()} — ',
                            style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            '$_estimatedMinutes MIN',
                            style: const TextStyle(
                              color: AppTheme.success,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
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

          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.25,
            maxChildSize: 0.75,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.white,
                  border: Border(
                    top: BorderSide(color: AppTheme.black, width: 3),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 48,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: AppTheme.black,
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status indicator
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _status == 'LIVE' ? AppTheme.success : AppTheme.greyDark,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _status,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Next stops - Bold timeline
                          const Text(
                            'NEXT STOPS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildStopItem('CITY CENTER', '2 MIN', true),
                          _buildStopItem('HOSPITAL', '8 MIN', false),
                          _buildStopItem('COLLEGE', '15 MIN', false),
                          _buildStopItem('RAILWAY STATION', '22 MIN', false),
                          
                          const SizedBox(height: 32),
                          
                          // Action buttons
                          const Text(
                            'ACTIONS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildActionButton(
                            'REPORT DELAY',
                            Icons.warning_amber,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportDelayScreen(
                                    busId: widget.bus.id,
                                    busName: widget.bus.name,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            'RATE BUS',
                            Icons.star,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RateBusScreen(
                                    busId: widget.bus.id,
                                    busName: widget.bus.name,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildActionButton(
                            'RATE DRIVER',
                            Icons.person,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RateDriverScreen(
                                    driverId: 'DRV001',
                                    busId: widget.bus.id,
                                    busName: widget.bus.name,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: AppTheme.white.withOpacity(0.9),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.black),
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStopItem(String name, String eta, bool isNext) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNext ? AppTheme.black : AppTheme.grey,
        border: Border.all(
          color: AppTheme.black,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isNext ? AppTheme.white : AppTheme.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isNext ? AppTheme.white : AppTheme.black,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            eta,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isNext ? AppTheme.success : AppTheme.greyDark,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          border: Border.all(color: AppTheme.black, width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.black, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
