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

/// نموذج نشاط حديث
class ActivityItem {
  final String title;
  final String meta;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  
  const ActivityItem({
    required this.title,
    required this.meta,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
  });
}

/// نموذج بيانات لوحة تحكم الإدارة
class ManagerDashboardData {
  final List<KpiValue> kpis;
  final List<SectionLink> sections;
  final List<ActivityItem> activities;
  
  const ManagerDashboardData({
    required this.kpis,
    required this.sections,
    required this.activities,
  });
}
