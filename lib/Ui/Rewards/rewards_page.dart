import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/RewardsAdmin/rewards_admin_bloc.dart';
import '../../Bloc/RewardsAdmin/rewards_admin_event.dart';
import '../../Bloc/RewardsAdmin/rewards_admin_state.dart';
import '../../Data/Repositories/rewards_admin_repository.dart';
// No intl import here to avoid TextDirection name clash
import '_widgets/summary_chip_card.dart';
import '_widgets/segmented_tabs.dart';
import '_widgets/grant_form.dart';
import '_widgets/employee_balance_card.dart';
import '_widgets/transactions_timeline.dart';
import '_widgets/group_rewards_card.dart';
import '_widgets/skeleton_rewards.dart';
import 'StoreAdmin/store_admin_page.dart';
import '../../Bloc/auth/auth_state.dart';
import '../../Bloc/auth/auth_bloc.dart';
import '../../Data/Models/role.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة التوكينز والمكافآت'),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: const BackButton(),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (_) => RewardsAdminBloc(MockRewardsAdminRepository())..add(RewardsLoad()),
          child: BlocBuilder<RewardsAdminBloc, RewardsAdminState>(
            builder: (ctx, st) {
              if (st is RewardsLoading || st is RewardsInitial) return const RewardsSkeleton();
              if (st is RewardsError) return Center(child: Text(st.message));
              final s = st as RewardsLoaded;
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.4,
                      ),
                      delegate: SliverChildListDelegate.fixed([
                        SummaryChipCard(color: const Color(0xFFE8F5E9), icon: Icons.trending_up_rounded, label: 'هذا الشهر', value: s.summary.thisMonth),
                        SummaryChipCard(color: const Color(0xFFFFF3CD), icon: Icons.monetization_on, label: 'إجمالي التوكينز', value: s.summary.totalIssued),
                        SummaryChipCard(color: const Color(0xFFF3E8FF), icon: Icons.emoji_events_outlined, label: 'الأداء', value: s.summary.performancePoints),
                        SummaryChipCard(color: const Color(0xFFE7F0FF), icon: Icons.groups_rounded, label: 'متوسط لكل موظف', value: s.summary.avgPerEmployee),
                      ]),
                    ),
                  ),
                  // زر إدارة المتجر بعرض كامل أسفل بطاقات الملخص
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final role = state is AuthRoleState ? state.role : Role.guest;
                          final allowed = role == Role.manager || role == Role.sysAdmin || role == Role.hr;
                          if (!allowed) return const SizedBox.shrink();
                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const StoreAdminPage())),
                              icon: const Icon(Icons.store_rounded),
                              label: const Text('ادارة متجر المكافات'),
                              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SegmentedTabsDelegate(
                      height:90,
                      tabs: const ['منح التوكينز','رصيد الموظفين','تاريخ المعاملات','المكافات الجماعية'],
                      currentIndex: s.currentTab,
                      onChanged: (i) => ctx.read<RewardsAdminBloc>().add(RewardsChangeTab(i)),
                    ),
                  ),
                  ...switch (s.currentTab) {
                    0 => [
                      SliverToBoxAdapter(
                        child: GrantForm(
                          state: s,
                          onSubmit: (emp, amt, reason, deduct) {
                            ctx.read<RewardsAdminBloc>().add(
                              RewardsGrantSubmit(employeeId: emp, amount: amt, reason: reason, deduct: deduct),
                            );
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              SnackBar(content: Text(deduct ? 'تم الخصم بنجاح' : 'تم منح التوكينز بنجاح')),
                            );
                          },
                          onQuick: (v) => ctx.read<RewardsAdminBloc>().add(RewardsQuickAmount(v)),
                          onSelectReason: (id) => ctx.read<RewardsAdminBloc>().add(RewardsSelectReason(id)),
                        ),
                      ),
                    ],
                    1 => [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, i) => Padding(
                              padding: EdgeInsets.only(bottom: i == s.balances.length - 1 ? 0 : 8),
                              child: EmployeeBalanceCard(item: s.balances[i]),
                            ),
                            childCount: s.balances.length,
                          ),
                        ),
                      ),
                    ],
                    2 => [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        sliver: SliverToBoxAdapter(child: TransactionsTimeline(items: s.transactions)),
                      ),
                    ],
                    3 => [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            GroupRewardsCard(title: 'إنجاز مشروع', subtitle: 'مكافأة لجميع المشاركين', points: 150, color: const Color(0xFFE8F5E9), onGrant: () => ctx.read<RewardsAdminBloc>().add(const RewardsGrantGroup('project'))),
                            const SizedBox(height: 8),
                            GroupRewardsCard(title: 'تحقيق الأهداف', subtitle: 'مكافأة الأداء الشهري', points: 100, color: const Color(0xFFE7F0FF), onGrant: () => ctx.read<RewardsAdminBloc>().add(const RewardsGrantGroup('goals'))),
                            const SizedBox(height: 8),
                            GroupRewardsCard(title: 'مناسبة خاصة', subtitle: 'مكافأة معيارية للمناسبات المحددة', points: 80, color: const Color(0xFFFFF3CD), onGrant: () => ctx.read<RewardsAdminBloc>().add(const RewardsGrantGroup('occasion'))),
                          ]),
                        ),
                      ),
                    ],
                    _ => [const SliverToBoxAdapter(child: SizedBox.shrink())],
                  },
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


