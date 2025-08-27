import 'package:flutter/material.dart';

class SpacingTokens {
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
}

class RadiusTokens {
  static const BorderRadius card = BorderRadius.all(Radius.circular(16));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(24));
}

BoxDecoration glassDecoration(BuildContext context) {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.18),
    borderRadius: RadiusTokens.card,
    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

Widget gradientBackground({required Widget child}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF2E3A8C), Color(0xFF6A3FA0), Color(0xFFF76B1C)],
      ),
    ),
    child: child,
  );
}


