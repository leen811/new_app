import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class HomeGuestPage extends StatelessWidget {
  const HomeGuestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الرئيسية - زائر', style: TextStyle(color: Colors.white))),
    );
  }
}


