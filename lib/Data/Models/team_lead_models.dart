import 'package:flutter/material.dart';

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

class MemberPerf {
  final String name;
  final String role;
  final int score;
  final String badge;
  final Color badgeColor;
  
  const MemberPerf({
    required this.name,
    required this.role,
    required this.score,
    required this.badge,
    required this.badgeColor,
  });
}

class TeamLeadDashboardData {
  final List<KpiValue> kpis;
  final List<SectionLink> sections;
  final List<MemberPerf> performance;
  
  const TeamLeadDashboardData({
    required this.kpis,
    required this.sections,
    required this.performance,
  });
}
