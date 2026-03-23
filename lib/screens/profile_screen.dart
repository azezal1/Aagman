import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                    Text(
                      'VERIFIED CITIZEN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primary,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(width: 16),
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
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Profile Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Profile Card
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.all(32),
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
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Profile Image
                                      Container(
                                        width: 128,
                                        height: 128,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppTheme.textPrimary, width: 3),
                                          color: Color(0xFFDBE1FF),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 80,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 32),
                                      
                                      // Profile Info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'TRANSIT IDENTITY',
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.primary,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'CITIZEN_092',
                                              style: GoogleFonts.spaceGrotesk(
                                                fontSize: 48,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.textPrimary,
                                                height: 1,
                                                letterSpacing: -1,
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.accent,
                                                    border: Border.all(color: AppTheme.textPrimary, width: 3),
                                                  ),
                                                  child: Text(
                                                    'FREQUENT COMMUTER',
                                                    style: GoogleFonts.spaceGrotesk(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w900,
                                                      color: AppTheme.textPrimary,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16),
                                                Text(
                                                  'LVL 12',
                                                  style: GoogleFonts.spaceGrotesk(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w900,
                                                    color: AppTheme.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 32),
                                  
                                  // Stats Grid
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard('TOTAL TRIPS', '412', null),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatCard('CO2 SAVED', '84KG', AppTheme.accent),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatCard('TRANSIT RANK', 'TOP 5%', null),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: _buildStatCard('POINTS', '2,450', AppTheme.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              
                              // ID Badge
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Text(
                                    'ID_092',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      
                      // Achievements Card
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.stars, color: AppTheme.primary, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'ACHIEVEMENTS',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              
                              // Achievement 1
                              Container(
                                padding: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  border: Border.all(color: AppTheme.textPrimary, width: 3),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppTheme.accent,
                                        border: Border.all(color: AppTheme.textPrimary, width: 3),
                                      ),
                                      child: Icon(Icons.eco, color: AppTheme.textPrimary),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ECO-WARRIOR',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '100 DAYS PUBLIC TRANSIT ONLY',
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
                                  ],
                                ),
                              ),
                              
                              // Achievement 2
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  border: Border.all(color: AppTheme.textPrimary, width: 3),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFDBE1FF),
                                        border: Border.all(color: AppTheme.textPrimary, width: 3),
                                      ),
                                      child: Icon(Icons.wb_sunny, color: Color(0xFF003EA8)),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'EARLY BIRD',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'TRIPS STARTED BEFORE 06:00 AM',
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
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),
                              
                              // View All Button
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppTheme.textPrimary, width: 3),
                                ),
                                child: Center(
                                  child: Text(
                                    'VIEW ALL 14 BADGES',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  
                  // Main Grid
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Travel History
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: EdgeInsets.all(32),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TRAVEL HISTORY',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: -1,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 4),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(color: AppTheme.primary, width: 2),
                                      ),
                                    ),
                                    child: Text(
                                      'EXPORT DATA',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              
                              // History Items
                              _buildHistoryItem(
                                Icons.directions_bus,
                                'ROUTE 42 - DOWNTOWN EXPRESS',
                                'OCT 24, 2023 · 08:42 AM',
                                'Plaza North → Terminal 2',
                                '\$2.40',
                              ),
                              SizedBox(height: 16),
                              _buildHistoryItem(
                                Icons.train,
                                'METRO BLUE LINE',
                                'OCT 23, 2023 · 05:15 PM',
                                'Central Hub → South Station',
                                '\$3.50',
                              ),
                              SizedBox(height: 16),
                              _buildHistoryItem(
                                Icons.directions_bus,
                                'ROUTE 101 - AIRPORT LINK',
                                'OCT 22, 2023 · 09:00 AM',
                                'Home Base → International Hub',
                                '\$5.00',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      
                      // Side Sections
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            // Saved Routes
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppTheme.border,
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
                                  Text(
                                    'SAVED ROUTES',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  _buildSavedRoute(Icons.home, 'HOME'),
                                  SizedBox(height: 12),
                                  _buildSavedRoute(Icons.work, 'WORK'),
                                  SizedBox(height: 12),
                                  _buildSavedRoute(Icons.fitness_center, 'GYM'),
                                  SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme.textMuted,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '+ ADD NEW QUICK-ROUTE',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.textMuted,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                            
                            // Account Settings
                            Container(
                              padding: EdgeInsets.all(24),
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
                                  Text(
                                    'ACCOUNT SETTINGS',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.textPrimary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  _buildSettingRow(
                                    Icons.notifications,
                                    'NOTIFICATIONS',
                                    'ACTIVE',
                                    true,
                                  ),
                                  SizedBox(height: 16),
                                  _buildSettingRow(
                                    Icons.payment,
                                    'PAYMENT',
                                    'VISA **** 0912',
                                    false,
                                  ),
                                  SizedBox(height: 16),
                                  _buildSettingRow(
                                    Icons.security,
                                    'PRIVACY',
                                    null,
                                    false,
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    height: 2,
                                    color: AppTheme.border,
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.logout, color: AppTheme.error, size: 20),
                                      SizedBox(width: 12),
                                      Text(
                                        'SIGN OUT IDENTITY',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: AppTheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

  Widget _buildStatCard(String label, String value, Color? valueColor) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppTheme.textMuted,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: valueColor ?? AppTheme.textPrimary,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
    IconData icon,
    String title,
    String date,
    String route,
    String price,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppTheme.primary, size: 20),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'COMPLETED',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textMuted,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: GoogleFonts.publicSans(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    route,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                price,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRoute(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    IconData icon,
    String label,
    String? value,
    bool isActive,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.textPrimary, size: 20),
            SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        if (value != null)
          isActive
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    border: Border.all(color: AppTheme.textPrimary, width: 2),
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                  ),
                )
        else
          Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
      ],
    );
  }
}
