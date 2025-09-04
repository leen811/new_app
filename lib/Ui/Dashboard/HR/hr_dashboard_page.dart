import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Bloc/HRDashboard/hr_dashboard_bloc.dart';
import '../../../Bloc/HRDashboard/hr_dashboard_event.dart';
import '../../../Bloc/HRDashboard/hr_dashboard_state.dart';
import '../../../Data/Repositories/hr_dashboard_repository.dart';
import '_widgets/hr_header_hero.dart';
import '_widgets/hr_kpi_card.dart';
import '_widgets/hr_section_tile.dart';
import '../../Common/press_fx.dart';

/// صفحة لوحة تحكم الموارد البشرية
class HrDashboardPage extends StatelessWidget {
  const HrDashboardPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: BlocProvider(
          create: (_) => HrDashboardBloc(MockHrDashboardRepository())
            ..add(const HRLoad()),
          child: BlocBuilder<HrDashboardBloc, HrDashboardState>(
            builder: (context, state) {
              if (state is HRLoading || state is HRInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              
              if (state is HRError) {
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
                          context.read<HrDashboardBloc>().add(const HRLoad());
                        },
                        child: const Text('إعادة المحاولة'),
                      ).withPressFX(),
                    ],
                  ),
                );
              }
              
              final loadedState = state as HRLoaded;
              
              return CustomScrollView(
                slivers: [
                  // رأس اللوحة
                  const SliverToBoxAdapter(
                    child: HrHeaderHero(),
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
                          .map((kpi) => HrKpiCard(kpi: kpi))
                          .toList(),
                    ),
                  ),
                  
                  // قائمة الأقسام
                  SliverList.builder(
                    itemCount: loadedState.data.sections.length,
                    itemBuilder: (context, index) {
                      return HrSectionTile(
                        link: loadedState.data.sections[index],
                      );
                    },
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
