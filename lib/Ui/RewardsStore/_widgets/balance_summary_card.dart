import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceSummaryCard extends StatelessWidget {
  final int coins;
  
  const BalanceSummaryCard({
    super.key,
    required this.coins,
  });
  
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('ar');
    
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1524).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
       
          const SizedBox(height: 8),
          Text(
            'رصيدك الحالي',
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF667085),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            formatter.format(coins),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'كوينز',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF667085),
              fontWeight: FontWeight.w600,
            ),
          ),
         
        ],
      ),
    );
  }
}
