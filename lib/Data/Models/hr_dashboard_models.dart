import 'package:flutter/material.dart';

/// نموذج بيانات مؤشر الأداء الرئيسي
class KpiValue {
  final String label;
  final String value;
  final String? delta;
  final IconData icon;
  final Color color;
  
  const KpiValue({
    required this.label,
    required this.value,
    this.delta,
    required this.icon,
    required this.color,
  });
}

/// نموذج رابط القسم
class SectionLink {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  
  const SectionLink({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });
}

/// نموذج بيانات لوحة تحكم الموارد البشرية
class HrDashboardData {
  final List<KpiValue> kpis;
  final List<SectionLink> sections;
  
  const HrDashboardData({
    required this.kpis,
    required this.sections,
  });
}
