import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class CompanyChatPage extends StatelessWidget {
  const CompanyChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الشات - Placeholder', style: TextStyle(color: Colors.white))),
    );
  }
}


