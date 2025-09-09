import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../Data/Models/employee_home_models.dart';
import '../../../Bloc/EmployeeHome/employee_home_bloc.dart';
import '../../../Bloc/EmployeeHome/employee_home_event.dart';
import '../../../Bloc/EmployeeHome/employee_home_state.dart';
import '../../../Data/Repositories/employee_home_repository.dart';
import '../../../Presentation/Common/navigation/routes_constants.dart';
import '_widgets/greeting_strip.dart';
import '_widgets/work_hours_card.dart';
import '_widgets/energy_progress_card.dart';
import '_widgets/coins_card.dart';
import '_widgets/performance_card.dart';
import '_widgets/quick_action_tile.dart';
import '_widgets/today_list_section.dart';
import '_widgets/achievement_item.dart';
import '../../Common/press_fx.dart';
import '../../../l10n/l10n.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> with AutomaticKeepAliveClientMixin {
  late final EmployeeHomeBloc _bloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _bloc = EmployeeHomeBloc(
      repository: EmployeeHomeRepository(),
    )..add(const EmployeeHomeLoaded());
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
      child: const _EmployeeHomeView(),
    );
  }
}

class _EmployeeHomeView extends StatelessWidget {
  const _EmployeeHomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: BlocBuilder<EmployeeHomeBloc, EmployeeHomeState>(
        builder: (context, state) {
          if (state is EmployeeHomeLoading) {
            return const _LoadingSkeleton();
          } else if (state is EmployeeHomeReady) {
            return _HomeContent(snapshot: state.snapshot);
          } else if (state is EmployeeHomeError) {
            return _ErrorView(message: state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final EmployeeSnapshot snapshot;

  const _HomeContent({required this.snapshot});

  double _tileExtentFor(double w) {
    if (w < 360) return 124;   // أصغر أجهزة
    if (w < 400) return 132;
    return 140;                // الأوسع
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return CustomScrollView(
      slivers: [
        // Greeting Strip
        const SliverToBoxAdapter(
          child: GreetingStrip(),
        ),
        
        // KPI Cards Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                switch (index) {
                  case 0:
                    return const WorkHoursCard(
                      shift: Duration(hours: 8),
                    );
                  case 1:
                    return EnergyProgressCard(pct: snapshot.energyPct / 100);
                  case 2:
                    return CoinsCard(value: snapshot.coins);
                  case 3:
                    return PerformanceCard(pct: snapshot.performancePct / 100);
                  default:
                    return const SizedBox.shrink();
                }
              },
              childCount: 4,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: _tileExtentFor(MediaQuery.sizeOf(context).width),
            ),
          ),
        ),
        
        // Quick Actions Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.home_employee_quick_actions_title,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 1),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                      QuickActionTile(
                      title: s.home_employee_quick_attendance_title,
                      description: s.home_employee_quick_attendance_subtitle,
                      icon: Icons.schedule,
                      iconBackgroundColor: const Color(0xFF60A5FA),
                      onTap: () => context.pushNamed(RoutesConstants.kAttendanceRouteName),
                    ),
                           QuickActionTile(
                      title: s.home_employee_quick_tasks_title,
                      description: s.home_employee_quick_tasks_subtitle,
                      icon: Icons.track_changes,
                      iconBackgroundColor: const Color(0xFFFB923C),
                      onTap: () => context.go('/?tab=3'),
                    ),
                  
                         QuickActionTile(
                      title: s.home_employee_quick_leaves_title,
                      description: s.home_employee_quick_leaves_subtitle,
                      icon: Icons.beach_access,
                      iconBackgroundColor: const Color(0xFF34D399),
                      onTap: () => context.pushNamed(RoutesConstants.kLeaveRouteName),
                    ),
                    QuickActionTile(
                      title: s.home_employee_quick_meetings_title,
                      description: s.home_employee_quick_meetings_subtitle,
                      icon: Icons.video_chat_rounded,
                      iconBackgroundColor: const Color(0xFFA78BFA),
                      onTap: () => context.pushNamed(RoutesConstants.kMyMeetingsRouteName),
                    ),
                
                  
               
                    QuickActionTile(
                      title: s.home_employee_quick_rewards_title,
                      description: s.home_employee_quick_rewards_subtitle,
                      icon: Icons.card_giftcard,
                      iconBackgroundColor: const Color.fromARGB(255, 246, 186, 21),
                      onTap: () => context.pushNamed(RoutesConstants.kRewardsRouteName),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Today's Activities
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TodayListSection(activities: snapshot.todayActivities),
          ),
        ),
        
        // Achievements Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 45.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      color: const Color(0xFF64748B),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s.home_employee_achievements_title,
                      style: GoogleFonts.cairo(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...snapshot.achievements.map((achievement) => 
                  AchievementItem(achievement: achievement)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Greeting skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 120,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        
        // KPI cards skeleton
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              childCount: 4,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 140,
            ),
          ),
        ),
        
        // Quick actions skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: List.generate(4, (index) => 
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Today activities skeleton
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

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
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: const Color(0xFF64748B),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              context.read<EmployeeHomeBloc>().add(const EmployeeHomeLoaded());
            },
            child: Text(s.common_retry),
          ).withPressFX(),
        ],
      ),
    );
  }
}
