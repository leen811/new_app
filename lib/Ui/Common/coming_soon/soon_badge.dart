import 'package:flutter/material.dart';

class SoonBadge extends StatelessWidget {
  const SoonBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF60A5FA), Color(0xFF7C3AED)]),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Center(child: Text('قريبًا', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
    );
  }
}


