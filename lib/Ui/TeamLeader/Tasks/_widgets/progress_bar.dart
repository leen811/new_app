import 'package:flutter/material.dart';

class AppProgressBar extends StatelessWidget {
  final double value; // 0..1
  const AppProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: 8,
        backgroundColor: const Color(0xFFF3F4F6),
        color: const Color(0xFF2F56D9),
      ),
    );
  }
}


