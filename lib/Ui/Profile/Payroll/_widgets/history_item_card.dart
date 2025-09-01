import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../Data/Models/payroll_models.dart';

class HistoryItemCard extends StatelessWidget {
  final PayrollHistoryEntry entry;
  final void Function()? onViewDetails;
  
  const HistoryItemCard({
    super.key, 
    required this.entry, 
    this.onViewDetails,
  });

  String _fmtAr(num v) => NumberFormat.decimalPattern('ar').format(v);
  String _fmtDeduction(num v) => 'ريال ${_fmtAr(v)}-';
  String _fmtAmount(num v) => 'ريال ${_fmtAr(v)}';

  String _monthName(int m) {
    const months = [
      'يناير','فبراير','مارس','أبريل','مايو','يونيو',
      'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final ratioPct = (entry.netRatio * 100).round(); // 81 مثلاً

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EEF5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // سطر علوي: زر عرض التفاصيل + عنوان الشهر
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onViewDetails,
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: Text(
                      'عرض التفاصيل', 
                      style: GoogleFonts.cairo(
                        fontSize: 12, 
                        fontWeight: FontWeight.w600
                      )
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: const Color(0xFF1E3A8A),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_monthName(entry.month)} ${entry.year}',
                    style: GoogleFonts.cairo(
                      fontSize: 13, 
                      fontWeight: FontWeight.w700, 
                      color: const Color(0xFF0F172A)
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ثلاث خانات أرقام
              Row(
                children: [
                  Expanded(
                    child: _kv('الراتب الإجمالي', _fmtAmount(entry.grossSalary), const Color(0xFF0F172A)),
                  ),
                  Expanded(
                    child: _kv('الخصومات', _fmtDeduction(entry.totalDeductions), const Color(0xFFEF4444)),
                  ),
                  Expanded(
                    child: _kv('صافي الراتب', _fmtAmount(entry.netSalary), const Color(0xFF16A34A)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // شريط النسبة
              Center(
                child: Text(
                  'نسبة صافي الراتب: %$ratioPct', 
                  style: GoogleFonts.cairo(
                    fontSize: 12, 
                    color: const Color(0xFF6B7280)
                  )
                ),
              ),
              const SizedBox(height: 6),
              _progressBar(entry.netRatio),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v, Color vColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          k, 
          style: GoogleFonts.cairo(
            fontSize: 12, 
            color: const Color(0xFF6B7280)
          )
        ),
        const SizedBox(height: 4),
        Text(
          v, 
          style: GoogleFonts.cairo(
            fontSize: 14, 
            fontWeight: FontWeight.w700, 
            color: vColor
          )
        ),
      ],
    );
  }

  Widget _progressBar(double ratio) {
    final clamped = ratio.clamp(0, 1);
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        return Stack(
          children: [
            Container(
              height: 6,
              width: w,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Container(
              height: 6,
              width: w * clamped,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        );
      },
    );
  }
}
