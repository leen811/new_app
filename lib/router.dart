import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'Ui/Joint/login_page.dart';
import 'Ui/Company/company_wizard_page.dart';
import 'Ui/ForgotPassword/forgot_method_page.dart';
import 'Ui/ForgotPassword/otp_verify_page.dart';
import 'Ui/Splash/splash_page.dart';
import 'Ui/Joint/home_shell.dart';
import 'Ui/Chat/chat_detail_page.dart';
import 'Core/Navigation/app_routes.dart';
import 'Ui/DigitalTwin/digital_twin_page.dart';
import 'Ui/Training/smart_training_page.dart';
import 'Ui/Training/courses_page.dart';
import 'Ui/Perf360/perf360_page.dart';
import 'Ui/Profile/PersonalInfo/personal_info_page.dart';
import 'Ui/Settings/general_settings_page.dart';

GoRouter buildRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadePage(const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fadePage(const LoginPage()),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          final q = state.uri.queryParameters;
          final initialIndex = int.tryParse(q['tab'] ?? '') ?? 0;
          return _fadePage(HomeShell(initialIndex: initialIndex));
        },
      ),
      GoRoute(
        path: '/company/new',
        pageBuilder: (context, state) => _fadePage(const CompanyWizardPage()),
      ),
      GoRoute(
        path: '/forgot',
        pageBuilder: (context, state) => _fadePage(const ForgotMethodPage()),
      ),
      GoRoute(
        path: '/forgot/verify',
        pageBuilder: (context, state) => _fadePage(const OtpVerifyPage()),
      ),
      GoRoute(
        path: '/chat/:id',
        pageBuilder: (context, state) => _fadePage(ChatDetailPage(conversationId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: digitalTwinRoute,
        pageBuilder: (context, state) => _fadePage(const DigitalTwinPage()),
      ),
      GoRoute(
        path: smartTrainingRoute,
        pageBuilder: (context, state) => _fadePage(const SmartTrainingPage()),
      ),
      GoRoute(
        path: smartTrainingCoursesRoute,
        pageBuilder: (context, state) => _fadePage(const CoursesPage()),
      ),
      GoRoute(
        path: '/profile/personal-info',
        pageBuilder: (context, state) => _fadePage(const PersonalInfoPage()),
      ),
      GoRoute(
        path: settingsGeneralRoute,
        pageBuilder: (context, state) => _fadePage(const GeneralSettingsPage()),
      ),
      GoRoute(
        path: settingsChangePasswordRoute,
        pageBuilder: (context, state) => _fadePage(const _PlaceholderPage(title: 'تغيير كلمة المرور')),
      ),
      GoRoute(
        path: legalTermsRoute,
        pageBuilder: (context, state) => _fadePage(const _PlaceholderPage(title: 'اتفاقية الاستخدام')),
      ),
      GoRoute(
        path: '/about/tos',
        pageBuilder: (context, state) => _fadePage(const _PlaceholderPage(title: 'اتفاقية الاستخدام')),
      ),
      GoRoute(
        path: '/about/privacy',
        pageBuilder: (context, state) => _fadePage(const _PlaceholderPage(title: 'سياسة الخصوصية')),
      ),
      GoRoute(
        path: perf360Route,
        pageBuilder: (context, state) => _fadePage(const Perf360Page()),
      ),
      GoRoute(
        path: assistantRoute,
        pageBuilder: (context, state) => _fadePage(const HomeShell(initialIndex: 2)),
      ),
    ],
  );
}

CustomTransitionPage _fadePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      final fadeOut = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: fadeIn,
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0.92).animate(fadeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.992, end: 1).animate(fadeIn),
            child: child,
          ),
        ),
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


