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

class PayrollDeductionsPage extends StatelessWidget {
  const PayrollDeductionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'خصومات الرواتب والأسباب',
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          leading: const BackButton(),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (_) => PayrollDeductionsBloc(MockPayrollRepository())
            ..add(const PayrollLoad(month: 2, year: 2024)),
          child: BlocBuilder<PayrollDeductionsBloc, PayrollDeductionsState>(
            builder: (context, state) {
              if (state is PayrollLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PayrollError) {
                return Center(
                  child: Text('حدث خطأ: ${state.message}', style: GoogleFonts.cairo()),
                );
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
    return CustomScrollView(
      slivers: [
        // 1) صف علوي
        SliverToBoxAdapter(
          child: TopActionsRow(
            monthLabel: _getMonthLabel(state.month, state.year),
            onExport: () => _showToast(context, "تم تصدير كشف الراتب (PDF)"),
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
            tabs: const ["ملخص الراتب", "تفاصيل الخصومات", "السجل التاريخي"],
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
                  onPressed: () => _showToast(context, "قريبًا: حاسبة الراتب"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("حاسبة الراتب", style: GoogleFonts.cairo()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showToast(context, "تم طلب كشف راتب مفصل"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("طلب كشف راتب مفصل", style: GoogleFonts.cairo()),
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
    final details = state.details;

    if (details.isEmpty) {
      return [
        const SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: Color(0xFF9CA3AF)),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد خصومات لهذا الشهر',
                    style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'جميع الخصومات ستظهر هنا عند توفرها',
                    style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
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
              currencyFmtAr: NumberFormat.decimalPattern("ar"),
              formatHijri: (date) => "هـ 1445/07/05", // مؤقتًا
            );
          },
          childCount: details.length + 1,
        ),
      ),
    ];
  }

  // تبويب السجل التاريخي
  List<Widget> _sliversForHistoryTab(BuildContext context, PayrollLoaded state) {
    final history = state.history;

    if (history.isEmpty) {
      return [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Text(
                "لا توجد سجلات تاريخية لهذا الشهر",
                style: TextStyle(
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
    final months = [
      'يناير','فبراير','مارس','أبريل','مايو','يونيو',
      'يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر',
    ];
    return '${months[month - 1]} $year';
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
    final total = details
        .map((d) => (d as dynamic).amount as num)
        .fold<num>(0, (sum, v) => sum + v);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الملخص",
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
                    "إجمالي الخصومات",
                    "ريال ${NumberFormat.decimalPattern('ar').format(total)}",
                  ),
                  const SizedBox(height: 12),
                  _summaryRow(
                    "إجمالي الخصومات بعد الخصم",
                    "ريال ${NumberFormat.decimalPattern('ar').format(total)}",
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
