import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:new_app/Bloc/Payroll/payroll_deductions_bloc.dart';
import 'package:new_app/Bloc/Payroll/payroll_deductions_event.dart';
import 'package:new_app/Bloc/Payroll/payroll_deductions_state.dart';

import 'package:new_app/Data/Repositories/payroll_repository.dart';
import 'package:new_app/Ui/Profile/Payroll/_widgets/top_actions_row.dart';
import '_widgets/summary_gradient_card.dart';
import '_widgets/segmented_tabs.dart';
import '_widgets/card_mandatory.dart';
import '_widgets/card_penalties.dart';
import '_widgets/card_optional.dart';
import '_widgets/card_breakdown.dart';
import '_widgets/detail_item_card.dart';
import '_widgets/history_item_card.dart';
import '../../../l10n/l10n.dart';

class PayrollDeductionsPage extends StatefulWidget {
  const PayrollDeductionsPage({super.key});

  @override
  State<PayrollDeductionsPage> createState() => _PayrollDeductionsPageState();
}

class _PayrollDeductionsPageState extends State<PayrollDeductionsPage> {
  late final PayrollDeductionsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PayrollDeductionsBloc(MockPayrollRepository())
      ..add(const PayrollLoad(month: 2, year: 2024));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            s.profile_payroll_app_bar_title,
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider.value(
          value: _bloc,
          child: BlocBuilder<PayrollDeductionsBloc, PayrollDeductionsState>(
            builder: (context, state) {
              if (state is PayrollLoading) {
                return const _PayrollLoadingSkeleton();
              }

              if (state is PayrollError) {
                return _PayrollErrorView(message: state.message);
              }

              if (state is PayrollLoaded) {
                return _buildLoadedContent(context, state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedContent(BuildContext context, PayrollLoaded state) {
    final s = S.of(context);
    return CustomScrollView(
      slivers: [
        // 1) صف علوي
        SliverToBoxAdapter(
          child: TopActionsRow(
            monthLabel: _getMonthLabel(state.month, state.year),
            onExport: () => _showToast(context, s.profile_payroll_toast_exported_pdf),
            onPickMonth: (month, year) => context.read<PayrollDeductionsBloc>().add(
              PayrollLoad(month: month, year: year),
            ),
          ),
        ),

        // 2) ملخص متدرّج
        SliverToBoxAdapter(child: SummaryGradientCard(summary: state.summary)),

        // 3) تابات مثبتة
        SliverPersistentHeader(
          pinned: true,
          delegate: SegmentedTabsDelegate(
            tabs: [
              s.profile_payroll_tab_summary,
              s.profile_payroll_tab_details,
              s.profile_payroll_tab_history,
            ],
            currentIndex: state.currentTab,
            onChanged: (index) =>
                context.read<PayrollDeductionsBloc>().add(PayrollChangeTab(index)),
          ),
        ),

        // 4) محتوى التبويب
        ...switch (state.currentTab) {
          0 => _sliversForSummaryTab(context, state),
          1 => _sliversForDetailsTab(context, state),
          2 => _sliversForHistoryTab(context, state),
          _ => [],
        },
      ],
    );
  }

  // تبويب الملخص
  List<Widget> _sliversForSummaryTab(BuildContext context, PayrollLoaded state) {
    final s = S.of(context);
    return [
      // مساحة علوية بسيطة
      const SliverToBoxAdapter(
        child: SizedBox(height: 16),
      ),
      
      SliverToBoxAdapter(
        child: CardMandatory(items: state.breakdown.mandatory),
      ),
      SliverToBoxAdapter(
        child: CardPenalties(items: state.breakdown.penalties),
      ),
      SliverToBoxAdapter(child: CardOptional(items: state.breakdown.optional)),
      SliverToBoxAdapter(
        child: CardBreakdown(summary: state.summary, breakdown: state.breakdown),
      ),
      // أزرار
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showToast(context, s.profile_payroll_toast_salary_calculator_soon),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(s.profile_payroll_button_salary_calculator, style: GoogleFonts.cairo()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showToast(context, s.profile_payroll_toast_detailed_slip_requested),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(s.profile_payroll_button_request_detailed_slip, style: GoogleFonts.cairo()),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // تبويب التفاصيل (من الـBloc مباشرة)
  List<Widget> _sliversForDetailsTab(BuildContext context, PayrollLoaded state) {
    final s = S.of(context);
    final details = state.details;

    if (details.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFF9CA3AF)),
                  const SizedBox(height: 16),
                  Text(
                    s.profile_payroll_empty_details_title,
                    style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.profile_payroll_empty_details_subtitle,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    // قائمة افتراضية + ملخص
    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == details.length) {
              return _buildDetailsSummary(context, details);
            }
            final item = details[index];
            return DeductionDetailCard(
              item: item,
              currencyFmtAr: NumberFormat.decimalPattern(s.localeName),
              formatHijri: (date) => 'هـ 1445/07/05', // مؤقتًا
            );
          },
          childCount: details.length + 1,
        ),
      ),
    ];
  }

  // تبويب السجل التاريخي
  List<Widget> _sliversForHistoryTab(BuildContext context, PayrollLoaded state) {
    final s = S.of(context);
    final history = state.history;

    if (history.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Center(
              child: Text(
                s.profile_payroll_empty_history,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final entry = history[index];
            return HistoryItemCard(
              entry: entry,
              onViewDetails: () {
                final bloc = context.read<PayrollDeductionsBloc>();
                bloc.add(PayrollLoad(month: entry.month, year: entry.year));
                bloc.add(const PayrollChangeTab(1));
              },
            );
          },
          childCount: history.length,
        ),
      ),
    ];
  }

  String _getMonthLabel(int month, int year) {
    final s = S.of(context);
    final locale = s.localeName;
    final date = DateTime(year, month, 1);
    final label = DateFormat.yMMMM(locale).format(date);
    return label;
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.cairo()),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDetailsSummary(BuildContext context, List details) {
    final s = S.of(context);
    final total = details
        .map((d) => (d as dynamic).amount as num)
        .fold<num>(0, (sum, v) => sum + v);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.profile_payroll_summary_title,
            style: GoogleFonts.cairo(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _summaryRow(
                    s.profile_payroll_summary_total_deductions,
                    '${s.currency_sar} ${NumberFormat.decimalPattern(s.localeName).format(total)}',
                  ),
                  const SizedBox(height: 12),
                  _summaryRow(
                    s.profile_payroll_summary_total_after_deduction,
                    '${s.currency_sar} ${NumberFormat.decimalPattern(s.localeName).format(total)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
        Text(value, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155))),
      ],
    );
  }
}

class _PayrollLoadingSkeleton extends StatelessWidget {
  const _PayrollLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Top actions skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 60,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        // Summary card skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        
        // Tabs skeleton
        SliverToBoxAdapter(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        
        // Content skeleton
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

class _PayrollErrorView extends StatelessWidget {
  final String message;

  const _PayrollErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
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
                context.read<PayrollDeductionsBloc>().add(const PayrollLoad(month: 2, year: 2024));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                s.common_retry,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
