import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:new_app/Data/Models/payroll_models.dart';

class SummaryGradientCard extends StatelessWidget {
  final PayrollSummary summary;

  const SummaryGradientCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern("ar");
    
    return Container(
      height: 350,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // الراتب الإجمالي
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الراتب الإجمالي',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ريال ${numberFormat.format(summary.grossSalary)}',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // إجمالي الخصومات
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'إجمالي الخصومات',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ريال ${numberFormat.format(summary.totalDeductions)}-',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFE53935),
              ),
            ),
            const SizedBox(height: 16),
            
            // البدلات والمكافآت
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'البدلات والمكافآت',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '+${numberFormat.format(summary.allowances)} ريال',
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2E7D32),
              ),
            ),
            const Spacer(),
            
            // صافي الراتب
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'صافي الراتب',
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ريال ${numberFormat.format(summary.net)}',
              style: GoogleFonts.cairo(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
