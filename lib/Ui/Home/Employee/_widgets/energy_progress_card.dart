import 'package:flutter/material.dart';
import 'kpi_small_card.dart';

class EnergyProgressCard extends StatelessWidget {
  final double pct;

  const EnergyProgressCard({
    super.key,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return KpiSmallCard(
      icon: Icons.flash_on,
      iconColor: const Color(0xFFFFD700),
      iconBg: const Color(0xFFFFF7E6),
      title: 'مستوى الطاقة',
      value: Text('${(pct * 100).round()}%'),
      footer: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 6,
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: const Color(0xFFF1F5F9),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
          ),
        ),
      ),
    );
  }
}
