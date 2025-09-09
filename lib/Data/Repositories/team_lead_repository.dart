import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Models/team_lead_models.dart';

abstract class TeamLeadRepository {
  Future<TeamLeadDashboardData> fetch();
}

class MockTeamLeadRepository implements TeamLeadRepository {
  @override
  Future<TeamLeadDashboardData> fetch() async {
    // أرقام مطابقة للسكرينات:
    final kpis = [
      KpiValue(
        label: 'المهام المكتملة',
        value: '89%',
        delta: '5%+',
        icon: Icons.center_focus_strong_rounded,
        color: const Color(0xFF10B981),
      ),
      KpiValue(
        label: 'أعضاء الفريق',
        value: '12',
        delta: '2+',
        icon: Icons.groups_rounded,
        color: const Color(0xFF2563EB),
      ),
      KpiValue(
        label: 'الاجتماعات هذا الأسبوع',
        value: '8',
        delta: '1+',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFFFF6D00),
      ),
      KpiValue(
        label: 'متوسط الأداء',
        value: '94%',
        delta: '3%+',
        icon: Icons.trending_up_rounded,
        color: const Color(0xFF7C3AED),
      ),
    ];
    
    final sections = [
      SectionLink(
        title: 'إدارة الفريق',
        subtitle: 'عرض وإدارة أعضاء فريقك',
        icon: Icons.group_rounded,
        color: const Color(0xFF2563EB),
      ),
      SectionLink(
        title: 'تقييم الأداء',
        subtitle: 'تقييم أداء أعضاء الفريق',
        icon: Icons.verified_rounded,
        color: const Color(0xFF16A34A),
      ),
      SectionLink(
        title: 'إدارة المهام',
        subtitle: 'توزيع ومتابعة المهام',
        icon: Icons.adjust_rounded,
        color: const Color(0xFF9333EA),
      ),
      SectionLink(
        title: 'الاجتماعات',
        subtitle: 'جدولة ومتابعة الاجتماعات',
        icon: Icons.chat_bubble_rounded,
        color: const Color(0xFFFF6D00),
      ),
      SectionLink(
        title: 'التقارير',
        subtitle: 'تقارير أداء الفريق',
        icon: Icons.stacked_bar_chart_rounded,
        color: const Color(0xFF7C3AED),
      ),
      SectionLink(
        title: 'التدريب والتطوير',
        subtitle: 'برامج تطوير الفريق',
        icon: Icons.psychology_rounded,
        color: const Color(0xFF16A34A),
      ),
      SectionLink(
        title: 'تحليلات Like for Like',
        subtitle: 'KPIs & Visuals للمقارنة العادلة',
        icon: Icons.insights_rounded,
        color: const Color(0xFF2563EB),
      ),
    ];
    
    final perf = [
      MemberPerf(
        name: 'سارة أحمد',
        role: 'مطور أول',
        score: 96,
        badge: 'ممتاز',
        badgeColor: const Color(0xFF16A34A),
      ),
      MemberPerf(
        name: 'محمد علي',
        role: 'مصمم UI/UX',
        score: 92,
        badge: 'جيد جدًا',
        badgeColor: const Color(0xFF2563EB),
      ),
      MemberPerf(
        name: 'فاطمة محمد',
        role: 'محلل بيانات',
        score: 88,
        badge: 'جيد',
        badgeColor: const Color(0xFFF59E0B),
      ),
      MemberPerf(
        name: 'خالد الأحمد',
        role: 'مطور تطبيقات',
        score: 94,
        badge: 'ممتاز',
        badgeColor: const Color(0xFF16A34A),
      ),
    ];
    
    return TeamLeadDashboardData(
      kpis: kpis,
      sections: sections,
      performance: perf,
    );
  }
}

class DioTeamLeadRepository implements TeamLeadRepository {
  final Dio dio;
  
  DioTeamLeadRepository(this.dio);
  
  @override
  Future<TeamLeadDashboardData> fetch() => Future.error(UnimplementedError());
}
