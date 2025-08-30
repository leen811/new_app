import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.10), border: Border.all(color: const Color(0xFFE6EAF2)), borderRadius: BorderRadius.circular(24)),
          child: child,
        ),
      ),
    );
  }
}


