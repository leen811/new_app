import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/TeamLead/team_lead_bloc.dart';
import '../../../Bloc/TeamLead/team_lead_event.dart';
import '../../../Bloc/TeamLead/team_lead_state.dart';
import '../../../Data/Repositories/team_lead_repository.dart';
import '_widgets/tl_header_hero.dart';
import '_widgets/tl_kpi_card.dart';
import '_widgets/tl_section_tile.dart';
import '_widgets/tl_team_performance.dart';
import '../../Common/press_fx.dart';
import '../../TeamLeader/team_management_page.dart';
import '../../Meetings/meetings_page.dart';
import '../../TeamLeader/Tasks/team_tasks_page.dart';
import '../../../Data/Models/team_lead_models.dart';
import '../../../Core/Motion/swipe_transitions.dart';
import '../../../l10n/l10n.dart';

class TeamLeadDashboardPage extends StatelessWidget {
  const TeamLeadDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => TeamLeadBloc(MockTeamLeadRepository())..add(const TLLoad()),
        child: BlocBuilder<TeamLeadBloc, TeamLeadState>(
          builder: (context, state) {
            if (state is TLLoading || state is TLInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is TLError) {
              return Center(
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
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TeamLeadBloc>().add(const TLLoad());
                      },
                      child: Text(s.common_retry),
                    ).withPressFX(),
                  ],
                ),
              );
            }
            
            final loadedState = state as TLLoaded;
            
            return CustomScrollView(
              slivers: [
                // رأس اللوحة
                const SliverToBoxAdapter(
                  child: TlHeaderHero(),
                ),
                
                // شبكة مؤشرات الأداء الرئيسية
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: loadedState.data.kpis
                        .map((kpi) => TlKpiCard(kpi: kpi))
                        .toList(),
                  ),
                ),
                
                // قائمة الأقسام
                SliverList.builder(
                  itemCount: loadedState.data.sections.length,
                  itemBuilder: (context, index) {
                    final link = loadedState.data.sections[index];
                    final onTap = link.title == 'إدارة الفريق'
                        ? () => context.pushSwipe(const TeamManagementPage())
                        : link.title == 'تقييم الأداء'
                            ? () {/* TODO: فتح صفحة تقارير الفريق عند توفرها */}
                        : link.title == 'إدارة المهام'
                            ? () => context.pushSwipe(const TeamTasksPage())
                        : link.title == 'الاجتماعات'
                            ? () => context.pushSwipe(const MeetingsPage())
                        : link.title == 'التقارير'
                            ? () {/* TODO: فتح صفحة تقارير الفريق عند توفرها */}
                        : link.title == 'التدريب والتطوير'
                            ? () {/* TODO: فتح صفحة تقارير الفريق عند توفرها */}
                        : link.onTap;
                    final overridden = SectionLink(
                      title: link.title,
                      subtitle: link.subtitle,
                      icon: link.icon,
                      color: link.color,
                      onTap: onTap,
                    );
                    return TlSectionTile(link: overridden);
                  },
                ),
                
                // أداء أعضاء الفريق
                SliverToBoxAdapter(
                  child: TlTeamPerformance(list: loadedState.data.performance),
                ),
                
                // مساحة إضافية في النهاية
                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
