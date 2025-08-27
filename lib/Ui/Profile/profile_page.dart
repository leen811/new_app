import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(
        child: Text('حسابي - Placeholder', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}


