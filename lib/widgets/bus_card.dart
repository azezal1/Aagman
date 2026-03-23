import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import 'capacity_bar.dart';

class BusCard extends StatefulWidget {
  final String busNumber;
  final String destination;
  final String eta;
  final int capacity;
  final bool isLive;

  const BusCard({
    super.key,
    required this.busNumber,
    required this.destination,
    required this.eta,
    required this.capacity,
    this.isLive = false,
  });

  @override
  State<BusCard> createState() => _BusCardState();
}

class _BusCardState extends State<BusCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // Handle tap
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 2 : 0,
          _pressed ? 2 : 0,
          0,
        ),
        width: 280,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.textPrimary, width: 3),
          borderRadius: BorderRadius.zero,
          boxShadow: _pressed
              ? []
              : [
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
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bus Number
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary,
                  ),
                  child: Text(
                    widget.busNumber,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Destination
                Text(
                  widget.destination.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // ETA
                Text(
                  widget.eta,
                  style: GoogleFonts.spaceGrotesk(
                    color: Color(0xFF004AC6),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Capacity Bar
                CapacityBar(capacity: widget.capacity),
              ],
            ),
            
            // Live Badge
            if (widget.isLive)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    border: Border.all(color: AppTheme.textPrimary, width: 2),
                  ),
                  child: Text(
                    'LIVE',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
