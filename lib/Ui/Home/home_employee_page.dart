import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class HomeEmployeePage extends StatelessWidget {
  const HomeEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('الرئيسية - موظف', style: TextStyle(color: Colors.white))),
    );
  }
}


