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
import '../../l10n/l10n.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  late final ProfileBloc _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc = ProfileBloc(context.read<IProfileRepository>())
      ..add(ProfileOpened());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BlocProvider.value(
      value: _bloc,
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Text(s.profile_app_bar_title, style: const TextStyle(color: Colors.black)),
            const SizedBox(height: 2),
            Text(
              s.profile_app_bar_subtitle,
              style: const TextStyle(color: Color(0xFF667085), fontSize: 12),
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
            return const _ProfileLoadingSkeleton();
          }
          if (state is ProfileError) {
            return _ProfileErrorView(message: state.message);
          }
          final success = state as ProfileSuccess;
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
                GradientHeader(user: success.user),
                const SizedBox(height: 12),
                PerformanceCard(perf: success.perf),
                const SizedBox(height: 12),
                SectionGroup(
                  title: s.profile_section_profile_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_profile_personal_info_title,
                      subtitle: s.profile_section_profile_personal_info_subtitle,
                      trailingIcon: Icons.person_outline,
                      onTap: () => context.goProfilePersonalInfo(),
                    ),
                  ],
                ),
                SectionGroup(
                  title: s.profile_section_ai_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_ai_assistant_title,
                      subtitle: s.profile_section_ai_assistant_subtitle,
                      trailingIcon: Icons.smart_toy_outlined,
                      onTap: () => context.goAssistant(),
                    ),
                    SectionTile(
                      title: s.profile_section_ai_digital_twin_title,
                      subtitle: s.profile_section_ai_digital_twin_subtitle,
                      trailingIcon: Icons.memory_outlined,
                      onTap: () => context.goDigitalTwin(),
                    ),
                    SectionTile(
                      title: s.profile_section_ai_analytics_title,
                      subtitle: s.profile_section_ai_analytics_subtitle,
                      trailingIcon: Icons.show_chart,
                    ),
                  ],
                ),
                SectionGroup(
                  title: s.profile_section_learning_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_learning_training_title,
                      subtitle: s.profile_section_learning_training_subtitle,
                      trailingIcon: Icons.school_outlined,
                      onTap: () => context.goSmartTraining(),
                    ),
                    SectionTile(
                      title: s.profile_section_learning_perf360_title,
                      subtitle: s.profile_section_learning_perf360_subtitle,
                      trailingIcon: Icons.assessment_outlined,
                      onTap: () => context.goPerf360(),
                    ),
                    SectionTile(
                      title: s.profile_section_learning_achievements_title,
                      subtitle: s.profile_section_learning_achievements_subtitle,
                      trailingIcon: Icons.emoji_events_outlined,
                      onTap: () => ComingSoon.show(
                        context,
                        featureName: s.profile_section_learning_achievements_title,
                        icon: Icons.emoji_events_rounded,
                      ),
                    ),
                  ],
                ),
                SectionGroup(
                  title: s.profile_section_financial_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_financial_payroll_deductions_title,
                      subtitle: s.profile_section_financial_payroll_deductions_subtitle,
                      trailingIcon: Icons.receipt_long_outlined,
                      onTap: () => context.goPayrollDeductions(),
                    ),
                  ],
                ),
                SectionGroup(
                  title: s.profile_section_notifications_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_notifications_email_title,
                      subtitle: s.profile_section_notifications_email_subtitle,
                      trailingIcon: Icons.mail_outline,
                      onTap: () => ComingSoon.show(
                        context,
                        featureName: s.profile_section_notifications_email_title,
                        icon: Icons.mark_email_unread_rounded,
                      ),
                    ),
                    SectionTile(
                      title: s.profile_section_notifications_smart_title,
                      subtitle: s.profile_section_notifications_smart_subtitle,
                      trailingIcon: Icons.notifications_none,
                    ),
                  ],
                ),
                SectionGroup(
                  title: s.profile_section_settings_title,
                  tiles: [
                    SectionTile(
                      title: s.profile_section_settings_general_title,
                      subtitle: s.profile_section_settings_general_subtitle,
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
                        children: [
                          Expanded(
                            child: Text(
                              s.profile_logout_label,
                              style: const TextStyle(
                                color: Color(0xFFB91C1C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFFB91C1C),
                          ),
                        ],
                      ),
                    ),
                  ).withPressFX(),
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

class _ProfileLoadingSkeleton extends StatelessWidget {
  const _ProfileLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 12),
        // Header skeleton
        Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 12),
        // Performance card skeleton
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 12),
        // Section groups skeleton
        ...List.generate(3, (index) => 
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  final String message;

  const _ProfileErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: const Color(0xFF64748B),
          ),
          const SizedBox(height: 16),
          Text(
            s.common_error_title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(ProfileOpened());
            },
            child: Text(s.common_retry),
          ).withPressFX(),
        ],
      ),
    );
  }
}
