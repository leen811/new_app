import 'package:flutter/material.dart';

class ReadOnlyRow extends StatelessWidget {
  const ReadOnlyRow({super.key, required this.label, required this.value});
  final String label; final String value;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(alignment: Alignment.centerRight, child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE6EAF2))),
        child: Align(alignment: Alignment.centerRight, child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF667085)))),
      )
    ]);
  }
}


