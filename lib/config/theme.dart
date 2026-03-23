import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // HTML Prototype Color Palette - Exact Translation
  static const Color primary = Color(0xFF2563EB);        // Primary blue
  static const Color background = Color(0xFFF9F9F9);     // Background
  static const Color surface = Color(0xFFFFFFFF);        // Surface/Card
  static const Color textPrimary = Color(0xFF1A1C1C);    // On-surface text
  static const Color accent = Color(0xFF6CF8BB);         // Secondary accent (green)
  static const Color textMuted = Color(0xFF434655);      // Muted text
  static const Color border = Color(0xFFE2E2E2);         // Surface border
  
  // Additional colors for compatibility
  static const Color black = textPrimary;
  static const Color white = surface;
  static const Color grey = background;
  static const Color greyDark = textMuted;
  
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color success = accent;
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  
  // Legacy compatibility aliases
  static const Color textSecondary = textMuted;
  static const Color textTertiary = textMuted;
  static const Color divider = border;
  static const Color secondary = accent;
  static const Color secondaryDark = Color(0xFF059669);
  static const Color accentLight = background;
  static const Color lightGrey = background;
  static const Color statusAmber = warning;
  static const Color info = primary;
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color surfaceVariant = background;
  
  // Helper methods
  static Color getBackground(BuildContext context) => background;
  static Color getSurface(BuildContext context) => surface;
  static Color getSurfaceVariant(BuildContext context) => background;
  static Color getTextPrimary(BuildContext context) => textPrimary;
  static Color getTextSecondary(BuildContext context) => textMuted;
  static Color getBorder(BuildContext context) => border;
  
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: background,
      
      // App Bar Theme - HTML: fixed header, bg #f8fafc, border-bottom 2px
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFF8FAFC),
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.5,
        ),
      ),
      
      // Card Theme - Sharp edges (borderRadius: 0), 3px border
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Sharp corners
          side: BorderSide(color: textPrimary, width: 3),
        ),
        margin: EdgeInsets.zero,
      ),
      
      // Button Theme - 3px border, sharp corners
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Sharp corners
            side: BorderSide(color: textPrimary, width: 3),
          ),
          textStyle: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ),
      
      // Input Theme - 3px border, sharp corners
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero, // Sharp corners
          borderSide: BorderSide(color: textPrimary, width: 3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: textPrimary, width: 3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: primary, width: 3),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: error, width: 3),
        ),
        hintStyle: GoogleFonts.publicSans(
          color: textMuted,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Typography - Space Grotesk for headlines, Public Sans for body
      textTheme: TextTheme(
        // Headlines - Space Grotesk, bold
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.3,
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        // Body - Public Sans
        bodyLarge: GoogleFonts.publicSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.publicSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.publicSans(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMuted,
          height: 1.4,
        ),
        // Labels - Space Grotesk, bold, uppercase
        labelLarge: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 1.5,
        ),
        labelMedium: GoogleFonts.spaceGrotesk(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textMuted,
          letterSpacing: 1.5,
        ),
        labelSmall: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textMuted,
          letterSpacing: 1.5,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      
      // Bottom Navigation - Active = solid blue bg fill
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: white,
        unselectedItemColor: textPrimary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 1.5,
        ),
      ),
      
      // Divider Theme - 4px solid
      dividerTheme: const DividerThemeData(
        color: textPrimary,
        thickness: 4,
      ),
    );
  }
}
