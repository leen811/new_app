import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBackdrop extends StatelessWidget {
  const GlassBackdrop({super.key, this.sigma = 18, this.opacity = 0.12, this.radius, this.padding, this.child});
  final double sigma;
  final double opacity;
  final BorderRadius? radius;
  final EdgeInsets? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).accessibleNavigation;
    final double s = reduce ? 4 : sigma;
    final double o = reduce ? 0.06 : opacity;
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: s, sigmaY: s),
        child: Container(
          color: Colors.white.withOpacity(o),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: [
          BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -2)),
        ],
      ),
      child: GlassBackdrop(radius: BorderRadius.circular(16), padding: const EdgeInsets.all(12), child: child),
    );
  }
}


