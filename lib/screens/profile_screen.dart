import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    final authService = AuthService();
    
    try {
      await authService.signOut();
      
      if (!context.mounted) return;
      
      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userEmail = authService.userEmail ?? 'user@example.com';
    final userName = userEmail.split('@')[0].toUpperCase();
    
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
                  // Profile Card
                  Container(
                    width: double.infinity,
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
                      children: [
                        // Profile Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.textPrimary, width: 3),
                            color: Color(0xFFDBE1FF),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // User Name
                        Text(
                          userName,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                            letterSpacing: -1,
                          ),
                        ),
                        SizedBox(height: 8),
                        
                        // Email
                        Text(
                          userEmail,
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            color: AppTheme.textMuted,
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            border: Border.all(color: AppTheme.textPrimary, width: 3),
                          ),
                          child: Text(
                            'VERIFIED CITIZEN',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        
                        // Edit Profile Button
                        Container(
                          width: double.infinity,
                          height: 48,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.textPrimary,
                                offset: const Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.surface,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              side: BorderSide(
                                color: AppTheme.textPrimary,
                                width: 3,
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'EDIT PROFILE',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('TRIPS', '412'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('CO2 SAVED', '84KG'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('RANK', 'TOP 5%'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard('POINTS', '2,450'),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Saved Routes
                  Container(
                    width: double.infinity,
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
                          'SAVED ROUTES',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildSavedRoute(Icons.home, 'HOME'),
                        SizedBox(height: 12),
                        _buildSavedRoute(Icons.work, 'WORK'),
                        SizedBox(height: 12),
                        _buildSavedRoute(Icons.fitness_center, 'GYM'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Travel History
                  Container(
                    width: double.infinity,
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
                          'TRAVEL HISTORY',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildHistoryItem(
                          Icons.directions_bus,
                          'ROUTE 42',
                          'OCT 24, 2023',
                          '\$2.40',
                        ),
                        SizedBox(height: 12),
                        _buildHistoryItem(
                          Icons.train,
                          'METRO BLUE',
                          'OCT 23, 2023',
                          '\$3.50',
                        ),
                        SizedBox(height: 12),
                        _buildHistoryItem(
                          Icons.directions_bus,
                          'ROUTE 101',
                          'OCT 22, 2023',
                          '\$5.00',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Account Settings
                  Container(
                    width: double.infinity,
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
                        SizedBox(height: 16),
                        _buildSettingRow(Icons.notifications, 'NOTIFICATIONS'),
                        SizedBox(height: 12),
                        _buildSettingRow(Icons.payment, 'PAYMENT'),
                        SizedBox(height: 12),
                        _buildSettingRow(Icons.security, 'PRIVACY'),
                        SizedBox(height: 16),
                        Container(
                          height: 2,
                          color: AppTheme.border,
                        ),
                        SizedBox(height: 16),
                        
                        // Sign Out Button
                        GestureDetector(
                          onTap: () => _handleSignOut(context),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.1),
                              border: Border.all(color: AppTheme.error, width: 3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: AppTheme.error, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  'SIGN OUT IDENTITY',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.error,
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
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
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
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppTheme.textPrimary,
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
    String price,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.publicSans(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedRoute(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _buildSettingRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textPrimary, size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 20),
      ],
    );
  }
}
