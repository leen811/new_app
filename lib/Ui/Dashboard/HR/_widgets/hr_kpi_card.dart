import 'package:flutter/material.dart';
import '../../../../Data/Models/hr_dashboard_models.dart';

/// بطاقة مؤشر الأداء الرئيسي
class HrKpiCard extends StatelessWidget {
  final KpiValue kpi;

  const HrKpiCard({super.key, required this.kpi});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الصف العلوي: الأيقونة والعنوان
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              
                Expanded(
                  child: Text(
                    kpi.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // القيمة الكبيرة
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  kpi.value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            // شارة الدلتا (إن وجدت)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getIconBackgroundColor(kpi),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(kpi.icon, color: _getIconColor(kpi), size: 25),
                ),
                if (kpi.delta != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        kpi.delta!,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEAB308),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // تحديد لون الأيقونة حسب نوع KPI
  Color _getIconColor(KpiValue kpi) {
    // استخدام hash من النص لتحديد لون ثابت لكل نوع
    final hash = kpi.label.hashCode;
    final colors = [
      const Color(0xFF3B82F6), // أزرق
      const Color(0xFF10B981), // أخضر
      const Color(0xFFF59E0B), // برتقالي
      const Color(0xFFEF4444), // أحمر
      const Color(0xFF8B5CF6), // بنفسجي
      const Color(0xFF06B6D4), // سماوي
    ];
    return colors[hash.abs() % colors.length];
  }

  // تحديد لون خلفية الأيقونة
  Color _getIconBackgroundColor(KpiValue kpi) {
    final iconColor = _getIconColor(kpi);
    return iconColor.withOpacity(0.12);
  }
}
