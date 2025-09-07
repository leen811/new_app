import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryChipCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final int value;
  const SummaryChipCard({super.key, required this.color, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final nf = NumberFormat.decimalPattern('ar');
    Color _darken(Color c) {
      final hsl = HSLColor.fromColor(c);
      final l = (hsl.lightness * 0.6).clamp(0.0, 1.0);
      return hsl.withLightness(l).toColor();
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Stack(
        children: [
          Positioned(
            top: 6,
            left: 6,
            child: Icon(icon, size: 24, color: _darken(color)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    nf.format(value),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w600, fontSize: 11, height: 1.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


