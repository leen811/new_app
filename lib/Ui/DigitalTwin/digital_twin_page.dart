import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class DigitalTwinPage extends StatelessWidget {
  const DigitalTwinPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('التوأم الرقمي - Placeholder', style: TextStyle(color: Colors.white))),
    );
  }
}


