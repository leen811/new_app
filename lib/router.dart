import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Ui/Joint/login_page.dart';
import 'Ui/Company/company_wizard_page.dart';
import 'Ui/ForgotPassword/forgot_method_page.dart';
import 'Ui/ForgotPassword/otp_verify_page.dart';
import 'Ui/Splash/splash_page.dart';
import 'Ui/Joint/home_shell.dart';
import 'Ui/Chat/chat_detail_page.dart';
import 'Ui/DigitalTwin/digital_twin_page.dart';
import 'Ui/Training/smart_training_page.dart';
import 'Ui/Training/courses_page.dart';
import 'Ui/Perf360/perf360_page.dart';
import 'Ui/Perf360/perf360_admin_page.dart';
import 'Presentation/Common/navigation/routes_constants.dart';
import 'Ui/Profile/PersonalInfo/personal_info_page.dart';
import 'Ui/Profile/Payroll/payroll_deductions_page.dart';
import 'Ui/Settings/general_settings_page.dart';
import 'Ui/Attendance/attendance_page.dart';
import 'Ui/Leave/leave_management_page.dart';
import 'Ui/RewardsStore/rewards_store_page.dart';
import 'Ui/Dashboard/HR/hr_dashboard_page.dart';
import 'Ui/Dashboard/Manager/manager_dashboard_page.dart';
import 'Ui/Dashboard/TeamLead/team_lead_dashboard_page.dart';
import 'Ui/PayrollAdmin/payroll_admin_page.dart';
import 'Core/Motion/app_motion.dart';
import 'Core/Navigation/app_routes.dart';

// تعريف التبويبات الرئيسية (Top-Level)
bool isTopLevelRoute(String? name) => const {
  '/', '/shell', '/home', '/chat', '/digital-twin', '/tasks', '/profile',
}.contains(name);

// Global key to preserve HomeShell state
final _homeShellKey = GlobalKey<HomeShellState>();

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _swipePage(const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _swipePage(const LoginPage()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          final q = state.uri.queryParameters;
          final initialIndex = int.tryParse(q['tab'] ?? '') ?? 0;
          return _swipePage(HomeShell(key: _homeShellKey, initialIndex: initialIndex));
        },
      ),
      GoRoute(
        path: '/company/new',
        pageBuilder: (context, state) => _swipePage(const CompanyWizardPage()),
      ),
      GoRoute(
        path: '/forgot',
        pageBuilder: (context, state) => _swipePage(const ForgotMethodPage()),
      ),
      GoRoute(
        path: '/forgot/verify',
        pageBuilder: (context, state) => _swipePage(const OtpVerifyPage()),
      ),
      GoRoute(
        path: '/chat/:id',
        pageBuilder: (context, state) => _swipePage(ChatDetailPage(conversationId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: digitalTwinRoute,
        name: 'digital-twin',
        pageBuilder: (context, state) => _swipePage(const DigitalTwinPage()),
      ),
      GoRoute(
        path: smartTrainingRoute,
        name: 'smart-training',
        pageBuilder: (context, state) => _swipePage(const SmartTrainingPage()),
      ),
      GoRoute(
        path: smartTrainingCoursesRoute,
        pageBuilder: (context, state) => _swipePage(const CoursesPage()),
      ),
      GoRoute(
        path: '/profile/personal-info',
        pageBuilder: (context, state) => _swipePage(const PersonalInfoPage()),
      ),
      GoRoute(
        path: '/profile/payroll-deductions',
        pageBuilder: (context, state) => _swipePage(const PayrollDeductionsPage()),
      ),
      GoRoute(
        path: settingsGeneralRoute,
        pageBuilder: (context, state) => _swipePage(const GeneralSettingsPage()),
      ),
      GoRoute(
        path: settingsChangePasswordRoute,
        pageBuilder: (context, state) => _swipePage(const _PlaceholderPage(title: 'تغيير كلمة المرور')),
      ),
      GoRoute(
        path: legalTermsRoute,
        pageBuilder: (context, state) => _swipePage(const _PlaceholderPage(title: 'اتفاقية الاستخدام')),
      ),
      GoRoute(
        path: '/about/tos',
        pageBuilder: (context, state) => _swipePage(const _PlaceholderPage(title: 'اتفاقية الاستخدام')),
      ),
      GoRoute(
        path: '/about/privacy',
        pageBuilder: (context, state) => _swipePage(const _PlaceholderPage(title: 'سياسة الخصوصية')),
      ),
      GoRoute(
        path: perf360Route,
        name: 'performance-360',
        pageBuilder: (context, state) => _swipePage(const Perf360Page()),
      ),
      GoRoute(
        path: '/admin/performance-360',
        name: RoutesConstants.kPerf360AdminRouteName,
        pageBuilder: (context, state) => _swipePage(const Perf360AdminPage()),
      ),
      GoRoute(
        path: '/hr/dashboard',
        name: 'hr-dashboard',
        pageBuilder: (context, state) => _swipePage(const HrDashboardPage()),
      ),
      GoRoute(
        path: '/manager/dashboard',
        name: 'manager-dashboard',
        pageBuilder: (context, state) => _swipePage(const ManagerDashboardPage()),
      ),
      GoRoute(
        path: '/team-lead/dashboard',
        name: 'team-lead-dashboard',
        pageBuilder: (context, state) => _swipePage(const TeamLeadDashboardPage()),
      ),
      GoRoute(
        path: assistantRoute,
        pageBuilder: (context, state) => _swipePage(const HomeShell(initialIndex: 2)),
      ),
      GoRoute(
        path: '/attendance',
        name: 'attendance',
        pageBuilder: (context, state) => _swipePage(const AttendancePage()),
      ),
      GoRoute(
        path: '/leave',
        name: 'leave',
        pageBuilder: (context, state) => _swipePage(const LeaveManagementPage()),
      ),
      GoRoute(
        path: '/rewards',
        name: 'rewards',
        pageBuilder: (context, state) => _swipePage(const RewardsStorePage()),
      ),
      GoRoute(
        path: '/admin/payroll',
        name: 'payroll-admin',
        pageBuilder: (context, state) => _swipePage(const PayrollAdminPage()),
      ),
    ],
  );
}

/// إنشاء صفحة انتقال بالسحب
CustomTransitionPage _swipePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: AppMotion.inDuration,
    reverseTransitionDuration: AppMotion.outDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // إيقاف الحركة إذا كان Reduce Motion مفعل
      if (AppMotion.reduce(context)) return child;
      
      // انتقال بالسحب من اليمين لليسار
      final tween = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // من اليمين
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Align(alignment: Alignment.centerRight, child: Text(title))),
      body: const Center(child: Text('قريباً')),
    );
  }
}


