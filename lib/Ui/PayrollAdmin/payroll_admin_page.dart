import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Bloc/PayrollAdmin/payroll_admin_bloc.dart';
import '../../Bloc/PayrollAdmin/payroll_admin_event.dart';
import '../../Bloc/PayrollAdmin/payroll_admin_state.dart';
import '../../Data/Repositories/payroll_admin_repository.dart';
import 'package:intl/intl.dart';

import '_widgets/summary_stat_card.dart';
import '_widgets/employees_filters_bar.dart';
import '_widgets/employee_payroll_card.dart';
import '_widgets/segmented_tabs.dart';
import '_widgets/skeleton_payroll.dart';

class PayrollAdminPage extends StatelessWidget {
  const PayrollAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure Arabic locale formatting is available
    Intl.defaultLocale = 'ar';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text('إدارة رواتب الموظفين'),
        centerTitle: true,
        leading: const BackButton(),
        actions: const [Padding(padding: EdgeInsetsDirectional.only(end: 12), child: Icon(Icons.grid_view_rounded))],
      ),
      body: BlocProvider(
        create: (_) => PayrollAdminBloc(const MockPayrollAdminRepository())..add(AdminPayrollLoad()),
        child: BlocBuilder<PayrollAdminBloc, AdminPayrollState>(
          builder: (ctx, st) {
            if (st is AdminPayrollLoading || st is AdminPayrollInitial) {
              return const PayrollSkeleton();
            }
            if (st is AdminPayrollError) {
              return Center(child: Text(st.message));
            }
            final s = st as AdminPayrollLoaded;

            final departments = s.employees.map((e) => e.department).toSet().toList()..sort();
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.0,
                    ),
                    delegate: SliverChildListDelegate.fixed([
                      SummaryStatCard(icon: Icons.attach_money_rounded, label: 'الرواتب الأساسية', value: s.summary.baseSalariesTotal, iconColor: const Color(0xFF10B981)),
                      SummaryStatCard(icon: Icons.groups_rounded,       label: 'إجمالي الموظفين',  value: s.summary.employeesCount,   iconColor: const Color(0xFF2563EB)),
                      SummaryStatCard(icon: Icons.calculate_rounded,    label: 'الخصومات',         value: s.summary.deductionsTotal, iconColor: const Color(0xFFF43F5E)),
                      SummaryStatCard(icon: Icons.trending_up_rounded,  label: 'البدلات',           value: s.summary.allowancesTotal, iconColor: const Color(0xFFF59E0B)),
                      SummaryStatCard(icon: Icons.savings_rounded,      label: 'صافي الرواتب',      value: s.summary.netTotal,        iconColor: const Color(0xFF16A34A)),
                      SummaryStatCard(icon: Icons.pie_chart_rounded,    label: 'المكافآت',          value: s.summary.bonusesTotal,    iconColor: const Color(0xFF8B5CF6)),
                    ]),
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: SegmentedTabsDelegate(
                    height: 44,
                    tabs: const ['قائمة الموظفين', 'التقارير', 'الإعدادات'],
                    currentIndex: s.currentTab,
                    onChanged: (i) => ctx.read<PayrollAdminBloc>().add(AdminChangeTab(i)),
                  ),
                ),

                ...switch (s.currentTab) {
                  0 => [
                    SliverToBoxAdapter(
                      child: EmployeesFiltersBar(
                        query: s.query,
                        filterLabel: s.filter,
                        departments: departments,
                        onQuery: (q) => ctx.read<PayrollAdminBloc>().add(AdminEmployeesSearchChanged(q)),
                        onFilter: (f) => ctx.read<PayrollAdminBloc>().add(AdminEmployeesFilterChanged(f)),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          if (i.isOdd) return const SizedBox(height: 8);
                          final index = i ~/ 2;
                          if (index >= s.employees.length) return null;
                          return EmployeePayrollCard(row: s.employees[index]);
                        },
                        childCount: s.employees.isEmpty ? 0 : s.employees.length * 2 - 1,
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                  1 => [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('التقارير — قريبًا', style: TextStyle(color: Color(0xFF6B7280))),
                      ),
                    ),
                  ],
                  2 => [
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('الإعدادات — قريبًا', style: TextStyle(color: Color(0xFF6B7280))),
                      ),
                    ),
                  ],
                  _ => [const SliverToBoxAdapter(child: SizedBox.shrink())],
                }
              ],
            );
          },
        ),
      ),
    );
  }
}


