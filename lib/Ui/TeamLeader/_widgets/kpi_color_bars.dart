import 'package:flutter/material.dart';

class KpiColorBars extends StatelessWidget {
  final int total;
  final int active;
  final int avgPerf;

  const KpiColorBars({super.key, required this.total, required this.active, required this.avgPerf});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          _Bar(
            color: const Color(0xFF1E63E9),
            icon: Icons.groups_rounded,
            title: 'إجمالي الأعضاء',
            value: total.toString(),
          ),
          const SizedBox(height: 10),
          _Bar(
            color: const Color(0xFF16A34A),
            icon: Icons.verified_rounded,
            title: 'الأعضاء النشطون',
            value: active.toString(),
          ),
          const SizedBox(height: 10),
          _Bar(
            color: const Color(0xFFF97316),
            icon: Icons.trending_up_rounded,
            title: 'متوسط الأداء',
            value: '$avgPerf%',
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  const _Bar({required this.color, required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ],
      ),
    );
  }
}


