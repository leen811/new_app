import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showEarningWaysSheet(BuildContext context) {
  final theme = Theme.of(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.80,
    ),
    builder: (_) => Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Row(
              children: [
                Icon(Icons.help_outline_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'كيف أكسب الكوينز؟',
                  style: GoogleFonts.cairo(
                    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black,
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'إغلاق',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).maybePop(),
                )
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'طرق سريعة لزيادة رصيدك داخل الشركة',
                style: GoogleFonts.cairo(
                  fontSize: 12, color: const Color(0xFF6B7280), fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // القائمة
            Expanded(
              child: ListView.separated(
                itemCount: _ways.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final w = _ways[i];
                                     return Container(
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: w.iconColor?.withOpacity(0.2) ?? const Color(0xFFE6E9F0)),
                       boxShadow: [
                         BoxShadow(
                           color: (w.iconColor ?? const Color(0xFFE6E9F0)).withOpacity(0.1),
                           blurRadius: 8,
                           offset: const Offset(0, 2),
                         ),
                       ],
                     ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                                                 Container(
                           width: 32, height: 32,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(8),
                             boxShadow: [
                               BoxShadow(
                                 color: (w.iconColor ?? const Color(0xFFE6E9F0)).withOpacity(0.15),
                                 blurRadius: 8,
                                 offset: const Offset(0, 2),
                               ),
                             ],
                             border: Border.all(color: w.iconColor?.withOpacity(0.3) ?? const Color(0xFFE6E9F0)),
                           ),
                           child: Icon(w.icon, size: 18, color: w.iconColor ?? theme.colorScheme.primary),
                         ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(w.title, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700)),
                              if (w.subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(w.subtitle!, style: GoogleFonts.cairo(fontSize: 12, color: const Color(0xFF6B7280))),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).maybePop(),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('تمام'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// عناصر الطرق المقترحة
class _Way {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  const _Way(this.icon, this.title, {this.subtitle, this.iconColor});
}

const List<_Way> _ways = [
  _Way(Icons.task_alt_rounded, 'إنجاز المهام قبل الوقت المحدد',
      subtitle: 'تسلّم المهمة بجودة عالية قبل الديدلاين',
      iconColor: Color(0xFF7C3AED)), // بنفسجي
  _Way(Icons.schedule_rounded, 'الالتزام بأوقات الدوام لفترة',
      subtitle: 'شهر كامل بدون تأخير أو غياب',
      iconColor: Color(0xFF10B981)), // أخضر
  _Way(Icons.workspace_premium_rounded, 'مكافأة من المدير',
      subtitle: 'تميّز استثنائي أو تحمّل مسؤولية إضافية',
      iconColor: Color(0xFF2F56D9)), // أزرق
  _Way(Icons.emoji_events_rounded, 'الفوز بمنافسات جماعية',
      subtitle: 'الهاكاثون/تحديات الفرق داخل الشركة',
      iconColor: Color(0xFFF59E0B)), // برتقالي
  // اقتراحات إضافية
  _Way(Icons.school_rounded, 'إكمال دورات تدريبية معتمدة',
      subtitle: 'شهادات مرتبطة بمهامك الحالية',
      iconColor: Color(0xFF0EA5E9)), // سماوي
  _Way(Icons.lightbulb_rounded, 'اقتراحات تحسّن المنتج تم اعتمادها',
      subtitle: 'فكرة أو تحسين UX تم تطبيقه للعميل',
      iconColor: Color(0xFFEF4444)), // أحمر
  _Way(Icons.bug_report_rounded, 'إصلاح أعطال حرجة بسرعة',
      subtitle: 'Hotfix ناجح خلال زمن قياسي',
      iconColor: Color(0xFF8B5CF6)), // بنفسجي فاتح
  _Way(Icons.volunteer_activism_rounded, 'التطوّع في فعاليات الشركة',
      subtitle: 'تنظيم مناسبات/Onboarding أو دعم مجتمعي',
      iconColor: Color(0xFF06B6D4)), // تركوازي
  _Way(Icons.support_agent_rounded, 'رضا العملاء أو الشركاء',
      subtitle: 'تقييمات عالية/شكر رسمي موثّق',
      iconColor: Color(0xFF84CC16)), // أخضر فاتح
  _Way(Icons.handshake_rounded, 'مساعدة الزملاء (Kudos)',
      subtitle: 'مساهمة واضحة في نجاح زميل/فريق',
      iconColor: Color(0xFFF97316)), // برتقالي داكن
];
