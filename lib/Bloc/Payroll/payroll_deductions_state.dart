import 'package:equatable/equatable.dart';
import '../../Data/Models/payroll_models.dart';

abstract class PayrollDeductionsState extends Equatable {
  const PayrollDeductionsState();

  @override
  List<Object?> get props => [];
}

class PayrollInitial extends PayrollDeductionsState {}

class PayrollLoading extends PayrollDeductionsState {}

class PayrollLoaded extends PayrollDeductionsState {
  final int month;
  final int year;
  final int currentTab;
  final PayrollSummary summary;
  final PayrollBreakdown breakdown;
  final List<DeductionDetail> details;
  final List<PayrollHistoryEntry> history; // جديد

  const PayrollLoaded({
    required this.month,
    required this.year,
    required this.currentTab,
    required this.summary,
    required this.breakdown,
    required this.details,
    required this.history,
  });

  @override
  List<Object?> get props => [month, year, currentTab, summary, breakdown, details, history];

  PayrollLoaded copyWith({
    int? month,
    int? year,
    int? currentTab,
    PayrollSummary? summary,
    PayrollBreakdown? breakdown,
    List<DeductionDetail>? details,
    List<PayrollHistoryEntry>? history,
  }) {
    return PayrollLoaded(
      month: month ?? this.month,
      year: year ?? this.year,
      currentTab: currentTab ?? this.currentTab,
      summary: summary ?? this.summary,
      breakdown: breakdown ?? this.breakdown,
      details: details ?? this.details,
      history: history ?? this.history,
    );
  }
}

class PayrollError extends PayrollDeductionsState {
  final String message;

  const PayrollError(this.message);

  @override
  List<Object?> get props => [message];
}
