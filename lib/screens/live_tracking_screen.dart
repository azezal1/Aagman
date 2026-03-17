import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';
import '../models/bus.dart';

class LiveTrackingScreen extends StatefulWidget {
  final Bus bus;

  const LiveTrackingScreen({super.key, required this.bus});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  GoogleMapController? _mapController;
  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  
  LatLng _busLocation = const LatLng(23.0225, 72.5714); // Default location
  Set<Marker> _markers = {};
  bool _isLoading = true;
  String _status = 'Connecting...';
  DateTime? _lastUpdate;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeTracking() async {
    // Get initial location
    await _getInitialLocation();
    
    // Subscribe to real-time updates
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
          _busLocation = LatLng(
            location['latitude'],
            location['longitude'],
          );
          _lastUpdate = DateTime.parse(location['timestamp']);
          _status = 'Live';
          _isLoading = false;
        });
        _updateMarker();
        _moveCamera();
      } else {
        setState(() {
          _status = 'No location data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error loading location';
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
                _status = 'Live';
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
      _markers = {
        Marker(
          markerId: MarkerId(widget.bus.id),
          position: _busLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
            title: widget.bus.name,
            snippet: 'Last updated: ${_getTimeAgo()}',
          ),
        ),
      };
    });
  }

  void _moveCamera() {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_busLocation, 15),
    );
  }

  String _getTimeAgo() {
    if (_lastUpdate == null) return 'Unknown';
    final diff = DateTime.now().difference(_lastUpdate!);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    return '${diff.inHours}h ago';
  }

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
          'Live Tracking',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _busLocation,
              zoom: 15,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Loading Indicator
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accent),
                ),
              ),
            ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.35,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Bus Info
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppTheme.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.directions_bus_rounded,
                            color: AppTheme.accent,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.bus.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.bus.type,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppTheme.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'On the way',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.accent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Arriving at City Center in 5 min',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Next Stops
                    Text(
                      'Next Stops',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    _buildStopItem('City Center', '5 min'),
                    _buildStopItem('Hospital', '15 min'),
                    _buildStopItem('College', '25 min'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem(String name, String eta) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.circle_outlined, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            eta,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
