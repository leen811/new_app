import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../Bloc/Rewards/rewards_bloc.dart';
import '../../Bloc/Rewards/rewards_event.dart';
import '../../Bloc/Rewards/rewards_state.dart';
import '../../Data/Models/rewards_models.dart';
import '../../Data/Repositories/rewards_repository.dart';
import '_widgets/balance_summary_card.dart';
import '_widgets/segmented_categories.dart';
import '_widgets/reward_large_card.dart';
import '_widgets/activity_section.dart';
import '_widgets/earnings_help_sheet.dart';

class RewardsStorePage extends StatefulWidget {
  const RewardsStorePage({super.key});

  @override
  State<RewardsStorePage> createState() => _RewardsStorePageState();
}

class _RewardsStorePageState extends State<RewardsStorePage> {
  late final RewardsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RewardsBloc(MockRewardsRepository())
      ..add(const RewardsLoad());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('متجر المكافئات'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1A1A1A),
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          }, 
        ),
        actions: [
          IconButton(
            tooltip: 'كيف أكسب الكوينز؟',
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => showEarningWaysSheet(context),
          ),
          const SizedBox(width: 6),
        ],
        backgroundColor: const Color(0xFFF8FAFC),
        foregroundColor: Colors.black87,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: Color(0xFFE6EAF2))),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider.value(
          value: _bloc,
          child: BlocBuilder<RewardsBloc, RewardsState>(
            builder: (context, state) {
              if (state is RewardsLoading || state is RewardsInitial) {
                return const _RewardsStoreLoadingSkeleton();
              }
              
              if (state is RewardsError) {
                return _RewardsStoreErrorView(message: state.message);
              }
              
              final loadedState = state as RewardsLoaded;
              
              return CustomScrollView(
                slivers: [
                  // سطر توضيحي صغير أعلى الشاشة
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: Center(
                        child: Text(
                          'استبدل كوينزك بمكافآت رائعة',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // كرت الرصيد
                  SliverToBoxAdapter(
                    child: BalanceSummaryCard(coins: loadedState.balance.coins),
                  ),
                  
                  // تابات مصغّرة (pinned)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SegmentedCategoriesDelegate(
                      labels: const ['جوائز داخلية', 'بطاقات شراء'],
                      current: loadedState.currentIndex,
                      onChanged: (index) => context.read<RewardsBloc>().add(
                        RewardsChangeCategory(index),
                      ),
                    ),
                  ),
                  
                  // محتوى الفئة الحالية
                  SliverList.builder(
                    itemCount: (loadedState.items[RewardCategory.values[loadedState.currentIndex]] ?? const []).length + 1,
                    itemBuilder: (context, index) {
                      final currentCategory = RewardCategory.values[loadedState.currentIndex];
                      final items = loadedState.items[currentCategory] ?? [];
                      
                      if (index < items.length) {
                        return RewardLargeCard(item: items[index]);
                      }
                      
                      // قسم "النشاط الأخير" بعد القائمة
                      return ActivitySection(items: loadedState.activity);
                    },
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

class _RewardsStoreLoadingSkeleton extends StatelessWidget {
  const _RewardsStoreLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Description skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 20,
            width: 200,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        
        // Balance card skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        
        // Segmented tabs skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        
        // Reward cards skeleton
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              height: 160,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            childCount: 4,
          ),
        ),
        
        // Activity section skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _RewardsStoreErrorView extends StatelessWidget {
  final String message;

  const _RewardsStoreErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'حدث خطأ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<RewardsBloc>().add(const RewardsLoad());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
