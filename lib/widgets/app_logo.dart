import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final bool useIcon; // Fallback to icon if SVG not available

  const AppLogo({
    super.key,
    this.size = 24,
    this.color,
    this.useIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    // If SVG file exists, use it. Otherwise, use fallback icon
    if (useIcon) {
      return Icon(
        Icons.directions_bus,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      );
    }

    return SvgPicture.asset(
      'assets/logo/logo.svg',
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
      // Fallback to icon if SVG fails to load
      placeholderBuilder: (context) => Icon(
        Icons.directions_bus,
        size: size,
        color: color ?? Theme.of(context).primaryColor,
      ),
    );
  }
}
