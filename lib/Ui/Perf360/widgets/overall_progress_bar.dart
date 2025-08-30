import 'package:flutter/material.dart';

class OverallProgressBar extends StatelessWidget {
  const OverallProgressBar({super.key, required this.value});
  final double value; // 0..1
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 8,
        child: Stack(children: [
          Container(color: const Color(0xFFEEF2FF)),
          FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: value.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF2F56D9), boxShadow: [BoxShadow(color: const Color(0xFF0B1524).withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 2))]),
            ),
          ),
        ]),
      ),
    );
  }
}


