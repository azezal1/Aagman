import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../models/bus.dart';

class RouteDetailsScreen extends StatelessWidget {
  final Bus bus;

  const RouteDetailsScreen({super.key, required this.bus});

  @override
  Widget build(BuildContext context) {
    // Sample stops matching HTML prototype
    final stops = [
      {
        'name': 'TERMINAL A CENTRAL',
        'time': '14:05',
        'status': 'departed',
        'label': 'DEPARTED 14:05',
        'icon': Icons.history,
      },
      {
        'name': 'OLD TOWN CROSSING',
        'time': '14:18',
        'status': 'departed',
        'label': 'DEPARTED 14:18',
        'icon': Icons.history,
      },
      {
        'name': 'CITY SQUARE STATION',
        'time': '14:32',
        'status': 'current',
        'label': 'PLATFORM 4 • ARRIVED',
        'icon': Icons.location_on,
        'tags': ['NEXT: 4 MINS', 'WIFI ENABLED'],
      },
      {
        'name': 'UNIVERSITY GATE',
        'time': '14:45',
        'status': 'upcoming',
        'label': 'ETA 14:45',
        'icon': Icons.schedule,
      },
      {
        'name': 'BUSINESS DISTRICT',
        'time': '14:58',
        'status': 'upcoming',
        'label': 'ETA 14:58',
        'icon': Icons.schedule,
      },
      {
        'name': 'SECTOR 14 BUS HUB',
        'time': '15:12',
        'status': 'terminal',
        'label': 'FINAL STOP • 15:12',
        'icon': Icons.flag,
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Top Navigation Bar
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
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'AAGMAN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.share, color: AppTheme.primary),
                    SizedBox(width: 16),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFE2E8F0),
                        border: Border.all(color: Color(0xFF0F172A), width: 2),
                      ),
                      child: Icon(Icons.person, color: Color(0xFF0F172A), size: 20),
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
                  // Route Header Card
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      border: Border.all(color: AppTheme.textPrimary, width: 3),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: AppTheme.white,
                                  child: Text(
                                    'LINE ${bus.name}',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'LIVE TRACKING',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: AppTheme.white,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'DOWNTOWN EXPRESS',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.white,
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'TERMINAL A → SECTOR 14 BUS HUB',
                              style: GoogleFonts.publicSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.white.withOpacity(0.9),
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Opacity(
                            opacity: 0.1,
                            child: Icon(
                              Icons.directions_bus,
                              size: 160,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  
                  // Route Timeline Section
                  Stack(
                    children: [
                      // Central Line
                      Positioned(
                        left: 23,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 4,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      
                      // Stops
                      Column(
                        children: stops.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stop = entry.value;
                          return _buildStopItem(context, stop, index);
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                  
                  // Live Geoposition Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE GEOPOSITION',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 256,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.textPrimary, width: 3),
                        ),
                        child: Stack(
                          children: [
                            // Map placeholder
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
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.white.withOpacity(0.8),
                                  border: Border.all(color: AppTheme.textPrimary, width: 2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'VEHICLE #8821',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.textPrimary,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Fullscreen Button
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Container(
                                width: 48,
                                height: 48,
                                color: AppTheme.textPrimary,
                                child: Icon(
                                  Icons.fullscreen,
                                  color: AppTheme.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem(BuildContext context, Map<String, dynamic> stop, int index) {
    final status = stop['status'];
    final isDeparted = status == 'departed';
    final isCurrent = status == 'current';
    final isUpcoming = status == 'upcoming';
    final isTerminal = status == 'terminal';
    
    return Padding(
      padding: EdgeInsets.only(bottom: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Circle
          Container(
            width: isCurrent ? 56 : 48,
            height: isCurrent ? 56 : 48,
            decoration: BoxDecoration(
              color: (isCurrent || isTerminal) ? AppTheme.textPrimary : AppTheme.surface,
              border: Border.all(
                color: AppTheme.textPrimary,
                width: isCurrent ? 3 : 2,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppTheme.primary,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              stop['icon'],
              color: (isCurrent || isTerminal) ? AppTheme.white : AppTheme.textPrimary,
              size: isCurrent ? 28 : 20,
            ),
          ),
          SizedBox(width: 24),
          
          // Stop Details
          Expanded(
            child: Opacity(
              opacity: isDeparted ? 0.4 : 1.0,
              child: isCurrent
                  ? _buildCurrentStopCard(stop)
                  : _buildRegularStopCard(stop, isTerminal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStopCard(Map<String, dynamic> stop) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stop['name'],
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            height: 1,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          stop['label'],
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    stop['time'],
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      height: 1,
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
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: (stop['tags'] as List<String>).map((tag) {
                  final isNext = tag.startsWith('NEXT');
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isNext ? AppTheme.accent : AppTheme.border,
                      border: Border.all(color: AppTheme.textPrimary, width: 2),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Positioned(
            top: -12,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: AppTheme.primary,
              child: Text(
                'NOW',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularStopCard(Map<String, dynamic> stop, bool isTerminal) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTerminal ? AppTheme.border : AppTheme.white,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stop['label'],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  stop['name'],
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          if (!isTerminal)
            Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
            ),
        ],
      ),
    );
  }
}
