import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class HomeManagerPage extends StatelessWidget {
  const HomeManagerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الرئيسية - مدير', style: TextStyle(color: Colors.white))),
    );
  }
}


