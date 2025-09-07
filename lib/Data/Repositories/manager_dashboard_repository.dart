import 'package:flutter/material.dart';
import '../Models/manager_dashboard_models.dart';

abstract class IManagerDashboardRepository {
  Future<ManagerDashboardData> getManagerDashboardData();
}

class MockManagerDashboardRepository implements IManagerDashboardRepository {
  @override
  Future<ManagerDashboardData> getManagerDashboardData() async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 800));
    
    return const ManagerDashboardData(
      kpis: [
        KpiValue(
          label: 'إجمالي الموظفين',
          value: '247',
          delta: '12+',
          icon: Icons.groups_rounded,
          color: Color(0xFF3B82F6), // أزرق
        ),
        KpiValue(
          label: 'الحاضرين اليوم',
          value: '198',
          delta: '5+',
          icon: Icons.diversity_3_rounded,
          color: Color(0xFF10B981), // أخضر
        ),
        KpiValue(
          label: 'طلبات الإجازة',
          value: '23',
          delta: '3+',
          icon: Icons.calendar_month_rounded,
          color: Color(0xFFF59E0B), // برتقالي
        ),
        KpiValue(
          label: 'إجمالي الرواتب',
          value: '2.4M',
          delta: '8+',
          icon: Icons.attach_money_rounded,
          color: Color(0xFF8B5CF6), // بنفسجي
        ),
      ],
      sections: [
        SectionLink(
          title: 'إدارة الموظفين',
          subtitle: 'عرض وإدارة بيانات الموظفين',
          icon: Icons.group_rounded,
          color: Color(0xFF3B82F6), // أزرق
        ),
        SectionLink(
          title: 'إدارة الرواتب',
          subtitle: 'إدارة شاملة لرواتب ومكافآت الموظفين',
          icon: Icons.article_rounded,
          color: Color(0xFF10B981), // أخضر
        ),
        SectionLink(
          title: 'تقارير الحضور',
          subtitle: 'تقارير مفصّلة وإحصائيات المؤسسة',
          icon: Icons.stacked_bar_chart_rounded,
          color: Color(0xFF8B5CF6), // بنفسجي
        ),
        SectionLink(
          title: 'إدارة المكافآت',
          subtitle: 'إدارة نظام النقاط والمكافآت',
          icon: Icons.card_giftcard_rounded,
          color: Color(0xFFF59E0B), // برتقالي
        ),
        SectionLink(
          title: 'مركز الإشعارات',
          subtitle: 'إرسال وإدارة الإشعارات',
          icon: Icons.notifications_rounded,
          color: Color(0xFFEF4444), // أحمر
        ),
        SectionLink(
          title: 'إشعارات البريد',
          subtitle: 'إدارة إشعارات البريد الإلكتروني',
          icon: Icons.mail_rounded,
          color: Color(0xFF6366F1), // بنفسجي مزرق
        ),
      ],
      activities: [
        ActivityItem(
          title: 'تم تسجيل دخول موظف جديد',
          meta: 'أحمد محمد',
          timeAgo: '5 دقائق',
          icon: Icons.person_add_rounded,
          iconColor: Color(0xFF10B981),
        ),
        ActivityItem(
          title: 'طلب إجازة',
          meta: 'فاطمة علي',
          timeAgo: '15 دقيقة',
          icon: Icons.calendar_today_rounded,
          iconColor: Color(0xFFF59E0B),
        ),
      ],
    );
  }
}
