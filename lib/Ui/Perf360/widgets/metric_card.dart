import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({super.key, required this.icon, required this.iconColor, required this.valueText, required this.caption});
  final IconData icon;
  final Color iconColor;
  final String valueText;
  final String caption;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(icon, color: iconColor, size: 36),
          const SizedBox(height: 8),
          Text(valueText, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20, color: iconColor)),
          const SizedBox(height: 4),
          const SizedBox(height: 2),
          Text(caption, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
        ]),
      ),
    );
  }
}


