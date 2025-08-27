import 'package:flutter/material.dart';
import '../Theme/tokens.dart' as core;

class GlassCard extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const GlassCard({super.key, required this.child, this.maxWidth = 720});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.all(24),
        decoration: core.glassDecoration(context),
        child: child,
      ),
    );
  }
}


