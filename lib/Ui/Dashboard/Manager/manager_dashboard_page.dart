import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/Manager/manager_dashboard_bloc.dart';
import '../../../Bloc/Manager/manager_dashboard_event.dart';
import '../../../Bloc/Manager/manager_dashboard_state.dart';
import '../../../Data/Repositories/manager_dashboard_repository.dart';
import '_widgets/manager_header_hero.dart';
import '_widgets/manager_kpi_card.dart';
import '_widgets/manager_section_tile.dart';
import '_widgets/manager_activity_feed.dart';
import '../../Common/press_fx.dart';

/// صفحة لوحة تحكم الإدارة
class ManagerDashboardPage extends StatelessWidget {
  const ManagerDashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocProvider(
          create: (_) => ManagerDashboardBloc(repository: MockManagerDashboardRepository())
            ..add(const ManagerLoad()),
          child: BlocBuilder<ManagerDashboardBloc, ManagerDashboardState>(
            builder: (context, state) {
              if (state is ManagerLoading || state is ManagerInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is ManagerError) {
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
                          context.read<ManagerDashboardBloc>().add(const ManagerLoad());
                        },
                        child: const Text('إعادة المحاولة'),
                      ).withPressFX(),
                    ],
                  ),
                );
              }
              
              final loadedState = state as ManagerLoaded;
              
              return CustomScrollView(
                slivers: [
                  // رأس اللوحة
                  const SliverToBoxAdapter(
                    child: ManagerHeaderHero(),
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
                          .map((kpi) => ManagerKpiCard(kpi: kpi))
                          .toList(),
                    ),
                  ),
                  
                  // قائمة الأقسام
                  SliverList.builder(
                    itemCount: loadedState.data.sections.length,
                    itemBuilder: (context, index) {
                      return ManagerSectionTile(
                        link: loadedState.data.sections[index],
                      );
                    },
                  ),
                  
                  // النشاطات الأخيرة
                  SliverToBoxAdapter(
                    child: ManagerActivityFeed(
                      activities: loadedState.data.activities,
                    ),
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
      ),
    );
  }
}
