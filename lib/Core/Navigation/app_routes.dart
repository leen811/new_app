import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Ui/Splash/splash_page.dart';
import '../../Ui/Joint/home_shell.dart';
import '../../Ui/Joint/login_page.dart';
import '../../Ui/Company/company_wizard_page.dart';
import '../../Ui/ForgotPassword/forgot_method_page.dart';
import '../../Ui/ForgotPassword/otp_verify_page.dart';
import '../../Ui/Chat/chat_detail_page.dart';
import '../../Ui/DigitalTwin/digital_twin_page.dart';
import '../../Ui/Training/smart_training_page.dart';
import '../../Ui/Training/courses_page.dart';
import '../../Ui/Perf360/perf360_page.dart';
import '../../Ui/Profile/PersonalInfo/personal_info_page.dart';
import '../../Ui/Profile/Payroll/payroll_deductions_page.dart';
import '../../Ui/Settings/general_settings_page.dart';
import '../Motion/swipe_transitions.dart';

// تعريف المسارات
const String digitalTwinRoute = '/digital-twin';
const String smartTrainingRoute = '/smart-training';
const String smartTrainingCoursesRoute = '/smart-training/courses';
const String assistantRoute = '/assistant';
const String perf360Route = '/performance-360';
const String profilePersonalInfoRoute = '/profile/personal-info';
const String settingsGeneralRoute = '/settings/general';
const String settingsChangePasswordRoute = '/settings/security/change-password';
const String legalTermsRoute = '/legal/terms';
const String payrollDeductionsRoute = '/profile/payroll-deductions';

/// تعريف التبويبات الرئيسية (Top-Level)
bool isTopLevelRoute(String? name) => const {
  '/', '/shell', '/home', '/chat', '/digital-twin', '/tasks', '/profile',
}.contains(name);

/// امتدادات للتنقل
extension AppRoutesExt on BuildContext {
  void goDigitalTwin() => GoRouter.of(this).push(digitalTwinRoute);
  void goSmartTraining() => GoRouter.of(this).push(smartTrainingRoute);
  void goSmartTrainingCourses() => GoRouter.of(this).push(smartTrainingCoursesRoute);
  void goAssistant() => GoRouter.of(this).go('/?tab=2');
  void goPerf360() => GoRouter.of(this).push(perf360Route);
  void goProfilePersonalInfo() => GoRouter.of(this).push(profilePersonalInfoRoute);
  void goSettingsGeneral() => GoRouter.of(this).push(settingsGeneralRoute);
  void goSettingsChangePassword() => GoRouter.of(this).push(settingsChangePasswordRoute);
  void goLegalTerms() => GoRouter.of(this).push(legalTermsRoute);
  void goPayrollDeductions() => GoRouter.of(this).push(payrollDeductionsRoute);
}

/// إدارة المسارات للتنقل الكلاسيكي (Navigator)
/// يمكن استخدامه كبديل لـ GoRouter
class AppRoutes {
  /// إنشاء مسار انتقال بالسحب
  static Route<dynamic> generate(RouteSettings settings) {
    final name = settings.name;
    
    // بناء الصفحة المطلوبة حسب الاسم
    final Widget page = _buildPageFromRouteSettings(settings);
    
    if (isTopLevelRoute(name)) {
      // تبويبات رئيسة: بدون أي أنيميشن مخصص ولا سحب
      return MaterialPageRoute(builder: (_) => page, settings: settings);
    }
    
    // صفحات داخلية: انتقال سحب
    return swipeRoute(page: page);
  }
  
  /// بناء الصفحة حسب إعدادات المسار
  static Widget _buildPageFromRouteSettings(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return const HomeShell();
      case '/splash':
        return const SplashPage();
      case '/login':
        return const LoginPage();
      case '/company/new':
        return const CompanyWizardPage();
      case '/forgot':
        return const ForgotMethodPage();
      case '/forgot/verify':
        return const OtpVerifyPage();
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>?;
        final conversationId = args?['id'] ?? '';
        return ChatDetailPage(conversationId: conversationId);
      case '/digital-twin':
        return const DigitalTwinPage();
      case '/smart-training':
        return const SmartTrainingPage();
      case '/smart-training/courses':
        return const CoursesPage();
      case '/perf360':
        return const Perf360Page();
      case '/profile/personal-info':
        return const PersonalInfoPage();
      case '/settings/general':
        return const GeneralSettingsPage();
      case '/profile/payroll-deductions':
        return const PayrollDeductionsPage();
      default:
        return _UnknownRoutePage(routeName: settings.name ?? '');
    }
  }
}

/// صفحة للمسارات غير المعروفة
class _UnknownRoutePage extends StatelessWidget {
  const _UnknownRoutePage({required this.routeName});
  
  final String routeName;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة غير موجودة'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'المسار "$routeName" غير موجود',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}


