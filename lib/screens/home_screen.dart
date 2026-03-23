import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';
import '../widgets/bus_card.dart';
import '../widgets/quick_access_button.dart';
import 'driver_login_screen.dart';
import 'travel_analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentLocation = "Fetching location...";
  bool _isLoadingLocation = true;
  Position? _currentPosition;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          _currentLocation = "Location services disabled";
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          setState(() {
            _currentLocation = "Location permission denied";
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          _currentLocation = "Location permission denied";
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      _updateLocationName(position);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentLocation = "Unable to get location";
        _isLoadingLocation = false;
      });
    }
  }

  void _updateLocationName(Position position) async {
    try {
      String locationName = _getLocationFromCoordinates(position.latitude, position.longitude);
      
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          
          if (place.locality != null && place.locality!.isNotEmpty) {
            locationName = place.locality!;
            if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
              locationName += ', ${place.administrativeArea}';
            }
          } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
            locationName = place.subLocality!;
            if (place.locality != null && place.locality!.isNotEmpty) {
              locationName += ', ${place.locality}';
            }
          } else if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
            locationName = place.administrativeArea!;
          }
        }
      } catch (e) {
        print('Geocoding failed, using fallback: $e');
      }
      
      if (!mounted) return;
      setState(() {
        _currentLocation = locationName;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentLocation = _getLocationFromCoordinates(position.latitude, position.longitude);
      });
    }
  }
  
  String _getLocationFromCoordinates(double lat, double lng) {
    if (lat >= 12.8 && lat <= 13.3 && lng >= 80.0 && lng <= 80.5) {
      return 'Chennai, Tamil Nadu';
    } else if (lat >= 18.9 && lat <= 19.3 && lng >= 72.7 && lng <= 73.0) {
      return 'Mumbai, Maharashtra';
    } else if (lat >= 28.4 && lat <= 28.9 && lng >= 76.8 && lng <= 77.3) {
      return 'Delhi';
    } else if (lat >= 12.8 && lat <= 13.2 && lng >= 77.4 && lng <= 77.8) {
      return 'Bangalore, Karnataka';
    } else if (lat >= 8.0 && lat <= 35.0 && lng >= 68.0 && lng <= 97.0) {
      return 'India';
    } else {
      return "${lat.toStringAsFixed(2)}°, ${lng.toStringAsFixed(2)}°";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Top App Bar
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFF0F172A), width: 2),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'AAGMAN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        border: Border.all(color: AppTheme.textPrimary, width: 3),
                      ),
                      child: Icon(Icons.person, color: AppTheme.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: AppTheme.textPrimary, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.textPrimary,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'WHERE TO?',
                              hintStyle: GoogleFonts.spaceGrotesk(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textMuted.withOpacity(0.5),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle search
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(color: AppTheme.textPrimary, width: 3),
                              ),
                            ),
                            child: Text(
                              'GO',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Quick Access Buttons (3-column grid)
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                    children: [
                      QuickAccessButton(
                        icon: Icons.schedule,
                        label: 'LIVE TIMES',
                        iconBgColor: Color(0xFFFFE5E5),
                        onTap: () {},
                      ),
                      QuickAccessButton(
                        icon: Icons.route,
                        label: 'ROUTES',
                        iconBgColor: Color(0xFFE5F3FF),
                        onTap: () {},
                      ),
                      QuickAccessButton(
                        icon: Icons.star,
                        label: 'SAVED',
                        iconBgColor: Color(0xFFFFF9E5),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Nearby Arrivals Section
                  Text(
                    'NEARBY ARRIVALS',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Horizontal Scrolling Bus Cards
                  SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        BusCard(
                          busNumber: '42A',
                          destination: 'Central Station',
                          eta: '2 MIN',
                          capacity: 45,
                          isLive: true,
                        ),
                        SizedBox(width: 12),
                        BusCard(
                          busNumber: '18',
                          destination: 'Airport Express',
                          eta: '8 MIN',
                          capacity: 72,
                        ),
                        SizedBox(width: 12),
                        BusCard(
                          busNumber: '7B',
                          destination: 'Tech Park',
                          eta: '15 MIN',
                          capacity: 28,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Analytics Card
                  _buildAnalyticsCard(),
                  const SizedBox(height: 24),
                  
                  // Map Section
                  _buildMapSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // FAB
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.accent,
          border: Border.all(color: AppTheme.textPrimary, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppTheme.textPrimary,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DriverLoginScreen()),
              );
            },
            child: Icon(
              Icons.directions_bus,
              color: AppTheme.textPrimary,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '127',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'TRIPS THIS MONTH',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.white.withOpacity(0.9),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TravelAnalyticsScreen(userId: 'user_001'),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.textPrimary,
                      border: Border.all(color: AppTheme.white, width: 2),
                    ),
                    child: Text(
                      'FULL REPORT',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: _buildMiniBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart() {
    final List<int> data = [45, 78, 62, 90, 55, 82, 70];
    final int maxValue = data.reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.textPrimary,
        border: Border.all(color: AppTheme.white, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((value) {
          return Container(
            width: 8,
            height: (value / maxValue) * 80,
            decoration: BoxDecoration(
              color: AppTheme.accent,
              border: Border.all(color: AppTheme.white, width: 1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Stack(
        children: [
          // Grayscale map placeholder
          Container(
            color: AppTheme.border,
            child: Center(
              child: Icon(
                Icons.map,
                size: 80,
                color: AppTheme.textMuted.withOpacity(0.3),
              ),
            ),
          ),
          
          // Status Badge
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.textPrimary, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textPrimary,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '12 BUSES NEARBY',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Zoom Buttons
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [
                _buildZoomButton(Icons.remove),
                SizedBox(width: 8),
                _buildZoomButton(Icons.add),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoomButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary,
            offset: Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: AppTheme.textPrimary, size: 20),
    );
  }
}
