import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_app/Data/Models/payroll_models.dart';

class CardBreakdown extends StatelessWidget {
  final PayrollSummary summary;
  final PayrollBreakdown breakdown;

  const CardBreakdown({
    super.key,
    required this.summary,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern("ar");
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // العنوان
            Text(
              'تفصيل الراتب',
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 16),
            
            // البنود
            _buildRow('الراتب الأساسي', 'ريال ${numberFormat.format(breakdown.basicSalary)}', Colors.black),
            _buildRow('البدلات والمكافآت', '+ ${numberFormat.format(breakdown.allowances)} ريال', const Color(0xFF2E7D32), isGreen: true),
            
            // الخصومات الإلزامية
            for (final item in breakdown.mandatory)
              _buildRow(item.title, 'ريال ${numberFormat.format(item.amount)}-', const Color(0xFFE53935)),
            
            // خصومات الجزاءات
            for (final item in breakdown.penalties)
              _buildRow(item.title, 'ريال ${numberFormat.format(item.amount)}-', const Color(0xFFE53935)),
            
            // الخصومات الاختيارية
            for (final item in breakdown.optional)
              _buildRow(item.title, 'ريال ${numberFormat.format(item.amount)}-', const Color(0xFFE53935)),
            
            const Divider(color: Color(0xFFEEF1F6), height: 24),
            
            // صافي الراتب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'صافي الراتب',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                ),
                Text(
                  'ريال ${numberFormat.format(summary.net)}',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, Color valueColor, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: isGreen ? FontWeight.w600 : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
