import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';
import '../models/bus.dart';
import 'live_tracking_screen.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _activeBuses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveBuses();
  }

  Future<void> _loadActiveBuses() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await _supabase.from('buses').select();

      if (!mounted) return;
      setState(() {
        _activeBuses = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading buses: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
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
                    Icon(Icons.menu, color: Color(0xFF0F172A)),
                    SizedBox(width: 16),
                    Text(
                      'AAGMAN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _loadActiveBuses,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF0F172A), width: 2),
                        ),
                        child: Icon(Icons.refresh, color: Color(0xFF0F172A), size: 24),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF0F172A), width: 2),
                      ),
                      child: Icon(Icons.person, color: Color(0xFF0F172A), size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Header
          Container(
            padding: EdgeInsets.all(16),
            color: AppTheme.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE BUSES',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textMuted,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${_activeBuses.length} BUSES LIVE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    border: Border.all(color: AppTheme.textPrimary, width: 3),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'LIVE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bus List
          Expanded(
            child: _isLoading
                ? Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadActiveBuses,
                    child: _activeBuses.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.border, width: 3),
                                  ),
                                  child: Icon(
                                    Icons.location_off,
                                    size: 40,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'NO ACTIVE BUSES',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textMuted,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _activeBuses.length,
                            itemBuilder: (context, index) {
                              final bus = _activeBuses[index];
                              return _buildBusCard(bus, index);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard(Map<String, dynamic> busData, int index) {
    final isLive = index == 0; // First bus is live for demo
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final bus = Bus(
              id: busData['id'].toString(),
              name: busData['name'],
              type: busData['type'] ?? 'Government',
              departureTime: '10:00 AM',
              arrivalTime: '11:00 AM',
              fare: busData['fare'] ?? 50,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveTrackingScreen(bus: bus),
              ),
            );
          },
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            border: Border.all(color: AppTheme.textPrimary, width: 3),
                          ),
                          child: Icon(
                            Icons.directions_bus,
                            color: AppTheme.white,
                            size: 32,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                busData['name'],
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                busData['route'] ?? 'ROUTE INFORMATION',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textMuted,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 2,
                      color: AppTheme.border,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STATUS',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textMuted,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                isLive ? 'ON ROUTE' : 'SCHEDULED',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isLive ? AppTheme.accent : AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TYPE',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textMuted,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                (busData['type'] ?? 'Government').toUpperCase(),
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            border: Border.all(color: AppTheme.textPrimary, width: 2),
                          ),
                          child: Text(
                            'TRACK',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Live Badge
              if (isLive)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      border: Border.all(color: AppTheme.textPrimary, width: 2),
                    ),
                    child: Text(
                      'LIVE',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.textPrimary,
                        letterSpacing: 1.5,
                      ),
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
