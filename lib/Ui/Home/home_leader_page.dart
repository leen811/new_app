import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class HomeLeaderPage extends StatelessWidget {
  const HomeLeaderPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الرئيسية - قائد فريق', style: TextStyle(color: Colors.white))),
    );
  }
}


