import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class TravelAnalyticsScreen extends StatefulWidget {
  final String userId;

  const TravelAnalyticsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TravelAnalyticsScreen> createState() => _TravelAnalyticsScreenState();
}

class _TravelAnalyticsScreenState extends State<TravelAnalyticsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  
  // Analytics data
  int _totalTrips = 127;
  double _totalDistance = 245.5;
  double _totalSpent = 1240.0;
  double _carbonSaved = 29.5;
  
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);
    
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() => _isLoading = false);
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
              color: AppTheme.white,
              border: Border(
                bottom: BorderSide(color: AppTheme.textPrimary, width: 2),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.textPrimary, width: 2),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: 20),
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'TRAVEL ANALYTICS',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Scrollable Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
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
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  border: Border.all(color: AppTheme.textPrimary, width: 3),
                                ),
                                child: Icon(Icons.calendar_month, color: AppTheme.primary, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('MMMM yyyy').format(DateTime.now()).toUpperCase(),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'MONTHLY SUMMARY',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.white.withOpacity(0.9),
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Stats Grid
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard('TRIPS', _totalTrips.toString(), Icons.directions_bus, AppTheme.primary),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard('DISTANCE', '${_totalDistance.toStringAsFixed(1)} KM', Icons.route, AppTheme.secondary),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard('SPENT', '₹${_totalSpent.toStringAsFixed(0)}', Icons.currency_rupee, Color(0xFFF59E0B)),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard('CO₂ SAVED', '${_carbonSaved.toStringAsFixed(1)} KG', Icons.eco, AppTheme.success),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Environmental Impact
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.success,
                            border: Border.all(color: AppTheme.textPrimary, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.textPrimary,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      border: Border.all(color: AppTheme.textPrimary, width: 3),
                                    ),
                                    child: Icon(Icons.eco, color: AppTheme.success, size: 24),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ENVIRONMENTAL IMPACT',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.white,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'BY CHOOSING PUBLIC TRANSPORT',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.white.withOpacity(0.9),
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                height: 2,
                                color: AppTheme.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildImpactItem(
                                      Icons.cloud_off,
                                      '${_carbonSaved.toStringAsFixed(1)} KG',
                                      'CO₂ SAVED',
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 60,
                                    color: AppTheme.white.withOpacity(0.3),
                                  ),
                                  Expanded(
                                    child: _buildImpactItem(
                                      Icons.forest,
                                      '${(_carbonSaved / 21).toStringAsFixed(1)}',
                                      'TREES EQUIVALENT',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Recent Trips Header
                        Text(
                          'RECENT TRIPS',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMuted,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Recent Trips List
                        _buildTripCard('42A', 'Central Station → Tech Park', 'MAR 23, 2026', '₹45'),
                        SizedBox(height: 12),
                        _buildTripCard('18', 'Airport → Downtown', 'MAR 22, 2026', '₹120'),
                        SizedBox(height: 12),
                        _buildTripCard('7B', 'Mall → University', 'MAR 21, 2026', '₹30'),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 3),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppTheme.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppTheme.white.withOpacity(0.9),
            letterSpacing: 1,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTripCard(String busNumber, String route, String date, String fare) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              border: Border.all(color: AppTheme.primary, width: 3),
            ),
            child: Icon(Icons.directions_bus, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BUS $busNumber',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  route,
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            fare,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
