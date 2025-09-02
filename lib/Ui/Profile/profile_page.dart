import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Data/Repositories/profile_repository.dart';
import '../../Bloc/profile/profile_bloc.dart';
import '../../Bloc/profile/profile_event.dart';
import '../../Bloc/profile/profile_state.dart';
import '../../Bloc/auth/auth_bloc.dart';
import '../../Bloc/auth/auth_event.dart';
import 'widgets/gradient_header.dart';
import 'widgets/performance_card.dart';
import 'widgets/section_group.dart';
import 'widgets/section_tile.dart';
import '../../Core/Navigation/app_routes.dart';
import '../Common/coming_soon/coming_soon.dart';
import '../Common/press_fx.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          ProfileBloc(ctx.read<IProfileRepository>())..add(ProfileOpened()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: const [
            Text('الملف الشخصي', style: TextStyle(color: Colors.black)),
            SizedBox(height: 2),
            Text(
              'إدارة ملفك الشخصي والإعدادات',
              style: TextStyle(color: Color(0xFF667085), fontSize: 12),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE9EDF4)),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return ListView(
              children: [
                Container(
                  height: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Color(0xFFE6EAF2)),
                  ),
                ),
              ],
            );
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          final s = state as ProfileSuccess;
          return NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollUpdateNotification) {
                if (n.metrics.pixels < -64) {
                  context.read<ProfileBloc>().add(ProfileRefreshed());
                }
              }
              return false;
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                GradientHeader(user: s.user),
                const SizedBox(height: 12),
                PerformanceCard(perf: s.perf),
                const SizedBox(height: 12),
                SectionGroup(
                  title: 'الملف الشخصي',
                  tiles: [
                    SectionTile(
                      title: 'المعلومات الشخصية',
                      subtitle: 'عرض وتحديث بياناتك الشخصية',
                      trailingIcon: Icons.person_outline,
                      onTap: () => context.goProfilePersonalInfo(),
                    ),
                  ],
                ),
                SectionGroup(
                  title: 'الذكاء الاصطناعي',
                  tiles: [
                    SectionTile(
                      title: 'المساعد الذكي',
                      subtitle: 'مساعد ذكي شخصي لتحسين أدائك',
                      trailingIcon: Icons.smart_toy_outlined,
                      onTap: () => context.goAssistant(),
                    ),
                    SectionTile(
                      title: 'التوأم الرقمي',
                      subtitle: 'نموذج رقمي متقدم لتحليل أدائك',
                      trailingIcon: Icons.memory_outlined,
                      onTap: () => context.goDigitalTwin(),
                    ),
                    const SectionTile(
                      title: 'التحليلات الذكية',
                      subtitle: 'تحليلات متقدمة بالذكاء الاصطناعي',
                      trailingIcon: Icons.show_chart,
                    ),
                  ],
                ),
                SectionGroup(
                  title: 'التطوير والتعلم',
                  tiles: [
                    SectionTile(
                      title: 'التدريب الذكي',
                      subtitle: 'برامج تدريب مخصصة وذكية',
                      trailingIcon: Icons.school_outlined,
                      onTap: () => context.goSmartTraining(),
                    ),
                    SectionTile(
                      title: 'تقييم الأداء 360°',
                      subtitle: 'تقييم شامل من جميع الزوايا',
                      trailingIcon: Icons.assessment_outlined,
                      onTap: () => context.goPerf360(),
                    ),
                    SectionTile(
                      title: 'الإنجازات والشارات',
                      subtitle: 'جميع إنجازاتك وشاراتك المكتسبة',
                      trailingIcon: Icons.emoji_events_outlined,
                      onTap: () => ComingSoon.show(
                        context,
                        featureName: 'الإنجازات والشارات',
                        icon: Icons.emoji_events_rounded,
                      ),
                    ),
                  ],
                ),
                SectionGroup(
                  title: 'الشؤون المالية',
                  tiles: [
                    SectionTile(
                      title: 'خصومات الراتب والأسباب',
                      subtitle: 'عرض خصومات راتبك والأسباب التفصيلية',
                      trailingIcon: Icons.receipt_long_outlined,
                      onTap: () => context.goPayrollDeductions(),
                    ),
                  ],
                ),
                SectionGroup(
                  title: 'التواصل والإشعارات',
                  tiles: [
                    SectionTile(
                      title: 'إشعارات البريد الإلكتروني',
                      subtitle: 'إدارة ومتابعة بريدك مع إمكانية الرد',
                      trailingIcon: Icons.mail_outline,
                      onTap: () => ComingSoon.show(
                        context,
                        featureName: 'إشعارات البريد الإلكتروني',
                        icon: Icons.mark_email_unread_rounded,
                      ),
                    ),
                    const SectionTile(
                      title: 'الإشعارات الذكية',
                      subtitle: 'إدارة إعدادات الإشعارات المخصصة',
                      trailingIcon: Icons.notifications_none,
                    ),
                  ],
                ),
                SectionGroup(
                  title: 'الإعدادات والتفضيلات',
                  tiles: [
                    SectionTile(
                      title: 'الإعدادات العامة',
                      subtitle: 'إعدادات التطبيق وتفضيلاتك الشخصية',
                      trailingIcon: Icons.settings_outlined,
                      onTap: () => context.goSettingsGeneral(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: () {
                      // تسجيل الخروج
                      context.read<AuthBloc>().add(const AuthLogoutRequested());
                      // العودة لشاشة تسجيل الدخول
                      context.go('/login');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              'تسجيل الخروج',
                              style: TextStyle(
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFFB91C1C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
