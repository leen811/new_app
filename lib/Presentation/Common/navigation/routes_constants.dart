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
  
  // مسارات أخرى
  static const String kLoginRoute = '/login';
  static const String kSplashRoute = '/splash';
  
  // منع إنشاء instance من هذا الكلاس
  RoutesConstants._();
}
