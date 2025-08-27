import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});
  @override
  Widget build(BuildContext context) {
    return gradientBackground(
      child: const GlassCard(child: Text('المهام - Placeholder', style: TextStyle(color: Colors.white))),
    );
  }
}


