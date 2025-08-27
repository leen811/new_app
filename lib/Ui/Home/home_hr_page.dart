import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class HomeHrPage extends StatelessWidget {
  const HomeHrPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الرئيسية - موارد بشرية', style: TextStyle(color: Colors.white))),
    );
  }
}


