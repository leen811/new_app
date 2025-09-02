import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/leave_models.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveType type;
  final int remaining;
  final int total;

  const LeaveBalanceCard({
    super.key,
    required this.type,
    required this.remaining,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getCardConfig(type);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: config.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // الرقم الكبير
          Text(
            '$remaining',
            style: GoogleFonts.cairo(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: config.numberColor,
            ),
          ),
          const SizedBox(width: 12),
          // النص الجانبي
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.displayName,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'من أصل $total يوم',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _CardConfig _getCardConfig(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return _CardConfig(
          backgroundColor: const Color(0xFFFFFFFF),
          borderColor: const Color(0xFFE5E5E5),
          numberColor: const Color(0xFF2E3A8C),
        );
      case LeaveType.sick:
        return _CardConfig(
          backgroundColor: const Color(0xFFFFFFFF),
          borderColor: const Color(0xFFE5E5E5),
          numberColor: const Color(0xFF6A3FA0),
        );
      case LeaveType.emergency:
        return _CardConfig(
          backgroundColor: const Color(0xFFFFFFFF),
          borderColor: const Color(0xFFE5E5E5),
          numberColor: const Color(0xFFF76B1C),
        );
    }
  }
}

class _CardConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color numberColor;

  const _CardConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.numberColor,
  });
}
