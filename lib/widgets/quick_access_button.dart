import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class QuickAccessButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color iconBgColor;
  final VoidCallback onTap;

  const QuickAccessButton({
    super.key,
    required this.icon,
    required this.label,
    required this.iconBgColor,
    required this.onTap,
  });

  @override
  State<QuickAccessButton> createState() => _QuickAccessButtonState();
}

class _QuickAccessButtonState extends State<QuickAccessButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        transform: Matrix4.translationValues(
          _pressed ? 2 : 0,
          _pressed ? 2 : 0,
          0,
        ),
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
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: widget.iconBgColor,
                border: Border.all(color: AppTheme.textPrimary, width: 3),
              ),
              child: Icon(
                widget.icon,
                color: AppTheme.textPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Label
            Expanded(
              child: Text(
                widget.label.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
