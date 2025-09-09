import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../Models/hr_dashboard_models.dart';

/// واجهة repository لبيانات لوحة تحكم الموارد البشرية
abstract class HrDashboardRepository {
  Future<HrDashboardData> fetch();
}

/// repository وهمي للاختبار
class MockHrDashboardRepository implements HrDashboardRepository {
  @override
  Future<HrDashboardData> fetch() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 500));
    
    // أرقام مطابقة للصور المطلوبة
    final kpis = [
      KpiValue(
        label: 'إجمالي الموظفين',
        value: '247',
        delta: '12+',
        icon: Icons.groups_rounded,
        color: const Color(0xFF2563EB),
      ),
      KpiValue(
        label: 'طلبات الإجازة المعلقة',
        value: '23',
        delta: '3+',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFFFF6D00),
      ),
      KpiValue(
        label: 'معدل الرضا الوظيفي',
        value: '85%',
        delta: '2%+',
        icon: Icons.emoji_events_rounded,
        color: const Color(0xFF9333EA),
      ),
      KpiValue(
        label: 'موظفين جدد هذا الشهر',
        value: '8',
        delta: '5+',
        icon: Icons.person_add_alt_1_rounded,
        color: const Color(0xFF16A34A),
      ),
    ];
    
    final sections = [
      SectionLink(
        title: 'إدارة الموظفين',
        subtitle: 'عرض وإدارة بيانات الموظفين',
        icon: Icons.group_rounded,
        color: const Color(0xFF2563EB),
      ),
      SectionLink(
        title: 'إدارة المكافآت',
        subtitle: 'إدارة نظام النقاط والمكافآت',
        icon: Icons.card_giftcard_rounded,
        color: const Color(0xFFF59E0B),
      ),
      SectionLink(
        title: 'إدارة الرواتب',
        subtitle: 'إدارة شاملة لرواتب ومكافآت الموظفين',
        icon: Icons.article_rounded,
        color: const Color(0xFF16A34A),
      ),
      SectionLink(
        title: 'طلبات الإجازة',
        subtitle: 'مراجعة والموافقة على طلبات الإجازة',
        icon: Icons.event_available_rounded,
        color: const Color(0xFFFF6D00),
      ),
      SectionLink(
        title: 'تقارير الحضور',
        subtitle: 'تقارير مفصلة وإحصائيات الموارد البشرية',
        icon: Icons.stacked_bar_chart_rounded,
        color: const Color(0xFF9333EA),
      ),
      SectionLink(
        title: 'تقييم الأداء',
        subtitle: 'نظام تقييم الأداء 360 درجة',
        icon: Icons.brightness_high_rounded,
        color: const Color(0xFF2563EB),
      ),
      SectionLink(
        title: 'تحليلات Like for Like',
        subtitle: 'KPIs & Visuals للمقارنة العادلة',
        icon: Icons.insights_rounded,
        color: const Color(0xFF2563EB),
      ),
    ];
    
    return HrDashboardData(kpis: kpis, sections: sections);
  }
}

/// repository حقيقي يستخدم Dio للاتصال بالخادم
class DioHrDashboardRepository implements HrDashboardRepository {
  final Dio dio;
  
  DioHrDashboardRepository(this.dio);
  
  @override
  Future<HrDashboardData> fetch() {
    // TODO: تنفيذ الاتصال الحقيقي بالخادم
    return Future.error(UnimplementedError('لم يتم تنفيذ الاتصال بالخادم بعد'));
  }
}
