/// مسارات ثابتة للتطبيق
/// 
/// هذا الملف يحتوي على جميع المسارات المستخدمة في التطبيق
/// لضمان التوحيد وتجنب الأخطاء في كتابة المسارات
class RoutesConstants {
  // المسار الرئيسي - يحتوي على HomeShell مع اختيار الأدوار
  static const String kRolesRoute = '/';
  
  // مسارات لوحات التحكم
  static const String kManagerDashboardRoute = '/manager/dashboard';
  static const String kTeamLeadDashboardRoute = '/team-lead/dashboard';
  static const String kHrDashboardRoute = '/hr/dashboard';
  
  // أسماء المسارات للتنقل بـ pushNamed
  static const String kAttendanceRouteName = 'attendance';
  static const String kLeaveRouteName = 'leave';
  static const String kRewardsRouteName = 'rewards';
  static const String kMyMeetingsRouteName = 'my-meetings';
  static const String kDigitalTwinRouteName = 'digital-twin';
  static const String kSmartTrainingRouteName = 'smart-training';
  static const String kPerformance360RouteName = 'performance-360';
  static const String kPerf360AdminRouteName = 'perf360-admin';
  static const String kHrDashboardRouteName = 'hr-dashboard';
  static const String kManagerDashboardRouteName = 'manager-dashboard';
  static const String kTeamLeadDashboardRouteName = 'team-lead-dashboard';
  static const String kL4LRouteName = 'l4l-analytics';

  // عناوين العرض
  static const String kL4LDisplayTitle = 'Like for Like (KPIs & Visuals)';
  
  // مسارات أخرى
  static const String kLoginRoute = '/login';
  static const String kSplashRoute = '/splash';
  
  // منع إنشاء instance من هذا الكلاس
  RoutesConstants._();
}
