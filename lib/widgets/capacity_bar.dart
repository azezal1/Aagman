import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class CapacityBar extends StatelessWidget {
  final int capacity; // 0-100

  const CapacityBar({
    super.key,
    required this.capacity,
  });

  Color _getCapacityColor() {
    if (capacity <= 50) {
      return AppTheme.accent; // Green
    } else if (capacity <= 80) {
      return AppTheme.warning; // Amber
    } else {
      return AppTheme.error; // Red
    }
  }

  String _getCapacityLabel() {
    if (capacity <= 50) {
      return 'AVAILABLE';
    } else if (capacity <= 80) {
      return 'FILLING UP';
    } else {
      return 'CROWDED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _getCapacityLabel(),
              style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              '$capacity%',
              style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.border,
            border: Border.all(color: AppTheme.textPrimary, width: 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: capacity / 100,
            child: Container(
              color: _getCapacityColor(),
            ),
          ),
        ),
      ],
    );
  }
}
