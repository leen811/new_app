import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kpi_small_card.dart';

class PerformanceCard extends StatelessWidget {
  final double pct;

  const PerformanceCard({
    super.key,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return KpiSmallCard(
      icon: Icons.trending_up_rounded,
      iconColor: const Color(0xFF10B981),
      iconBg: const Color(0xFFEFFDF5),
      title: 'تقييم الأداء',
      value: Text('${(pct * 100).round()}%'),
      footer: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F6EF),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          'ممتاز',
          style: GoogleFonts.cairo(
            fontSize: 11,
            color: const Color(0xFF059669),
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
