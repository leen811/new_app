import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../Data/Models/payroll_models.dart';

class DeductionDetailCard extends StatelessWidget {
  final DeductionDetail item;
  final NumberFormat currencyFmtAr;
  final String Function(DateTime) formatHijri;

  const DeductionDetailCard({
    super.key,
    required this.item,
    required this.currencyFmtAr,
    required this.formatHijri,
  });

  @override
  Widget build(BuildContext context) {
    final amountStr = "ريال ${currencyFmtAr.format(item.amount)}";
    final hasPercent = item.percentOfSalary != null;
    final description = (item.description ?? '').trim();
    final hasDescription = description.isNotEmpty;
    final lastUpdate = item.lastUpdate;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EEF5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العمود الأيسر (مبلغ/نسبة/تاريخ) — بدون Spacer (سبب التهنيج)
            SizedBox(
              width: 96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // المبلغ
                  Text(
                    amountStr,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _amountColor(item.kind),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // نسبة من الراتب (إن وجدت)
                  if (hasPercent) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _amountColor(item.kind).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "${(item.percentOfSalary! * 100).toStringAsFixed(1)}% من الراتب",
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _amountColor(item.kind),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // تاريخ آخر تحديث (إن وجد)
                  if (lastUpdate != null)
                    Row(
                      children: [
                        const Icon(Icons.event_outlined, size: 16, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            formatHijri(lastUpdate),
                            style: GoogleFonts.cairo(fontSize: 12, color: const Color(0xFF94A3B8)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // العمود الأيمن — العنوان/الوصف/الشارات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان + أيقونة
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _iconBg(item.kind),
                          border: Border.all(color: _iconColor(item.kind).withOpacity(0.2), width: 1),
                        ),
                        child: Icon(
                          item.icon ?? Icons.help_outline, // حماية لو الأيقونة null
                          size: 18,
                          color: _iconColor(item.kind),
                        ),
                      ),
                    ],
                  ),

                  if (hasDescription) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.cairo(fontSize: 12, color: const Color(0xFF6B7280), height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // الشارات (Wrap آمن بدل Row لو زادت المساحة)
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    alignment: WrapAlignment.end,
                    children: [
                      // شارة التكرار
                      _chip(
                        label: _freqLabel(item.frequency),
                        bg: const Color(0xFFF1F5F9),
                        fg: const Color(0xFF475569),
                        bordered: true,
                      ),
                      // شارة النوع
                      _chip(
                        label: _kindText(item.kind),
                        bg: _badgeBg(item.kind),
                        fg: Colors.white,
                        shadow: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Helpers ===

  Color _amountColor(DeductionKind kind) {
    switch (kind) {
      case DeductionKind.mandatory:
        return const Color(0xFF0F172A);
      case DeductionKind.penalty:
        return const Color(0xFFEF4444);
      case DeductionKind.optional:
        return const Color(0xFF16A34A);
    }
  }

  Color _iconBg(DeductionKind kind) {
    switch (kind) {
      case DeductionKind.mandatory:
        return const Color(0xFFEEF2FF);
      case DeductionKind.penalty:
        return const Color(0xFFFEE2E2);
      case DeductionKind.optional:
        return const Color(0xFFECFDF5);
    }
  }

  Color _iconColor(DeductionKind kind) {
    switch (kind) {
      case DeductionKind.mandatory:
        return const Color(0xFF1E3A8A);
      case DeductionKind.penalty:
        return const Color(0xFFDC2626);
      case DeductionKind.optional:
        return const Color(0xFF16A34A);
    }
  }

  Color _badgeBg(DeductionKind kind) {
    switch (kind) {
      case DeductionKind.mandatory:
        return const Color(0xFF1E3A8A);
      case DeductionKind.penalty:
        return const Color(0xFFEF4444);
      case DeductionKind.optional:
        return const Color(0xFF16A34A);
    }
  }

  String _kindText(DeductionKind kind) {
    switch (kind) {
      case DeductionKind.mandatory:
        return "إلزامي";
      case DeductionKind.penalty:
        return "جزاء"; // كانت "جاري" بالغلط
      case DeductionKind.optional:
        return "اختياري";
    }
  }

  String _freqLabel(Frequency f) {
    switch (f) {
      case Frequency.monthly:
        return "تكرار: شهري";
      case Frequency.once:
        return "تكرار: مرة واحدة";
      case Frequency.weekly:
        return "تكرار: أسبوعي";
      case Frequency.daily:
        return "تكرار: يومي";
    }
  }

  Widget _chip({
    required String label,
    required Color bg,
    required Color fg,
    bool bordered = false,
    bool shadow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: bordered ? Border.all(color: const Color(0xFFE2E8F0), width: 1) : null,
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: bg.withOpacity(0.35),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
