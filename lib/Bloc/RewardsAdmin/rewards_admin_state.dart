import 'package:equatable/equatable.dart';
import '../../Data/Models/rewards_models.dart';

abstract class RewardsAdminState extends Equatable {
  const RewardsAdminState();
  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsAdminState { const RewardsInitial(); }
class RewardsLoading extends RewardsAdminState { const RewardsLoading(); }

class RewardsLoaded extends RewardsAdminState {
  final int currentTab; // 0..3
  final RewardsSummary summary;
  final List<RewardReason> reasons;
  final String query;
  final int? quickAmount;
  final String? selectedReasonId;
  final List<EmployeeTokenBalance> balances;
  final List<RewardTransaction> transactions;

  const RewardsLoaded({
    required this.currentTab,
    required this.summary,
    required this.reasons,
    required this.query,
    required this.quickAmount,
    required this.selectedReasonId,
    required this.balances,
    required this.transactions,
  });

  RewardsLoaded copyWith({
    int? currentTab,
    RewardsSummary? summary,
    List<RewardReason>? reasons,
    String? query,
    int? quickAmount,
    String? selectedReasonId,
    List<EmployeeTokenBalance>? balances,
    List<RewardTransaction>? transactions,
  }) => RewardsLoaded(
        currentTab: currentTab ?? this.currentTab,
        summary: summary ?? this.summary,
        reasons: reasons ?? this.reasons,
        query: query ?? this.query,
        quickAmount: quickAmount ?? this.quickAmount,
        selectedReasonId: selectedReasonId ?? this.selectedReasonId,
        balances: balances ?? this.balances,
        transactions: transactions ?? this.transactions,
      );

  @override
  List<Object?> get props => [currentTab, summary, reasons, query, quickAmount, selectedReasonId, balances, transactions];
}

class RewardsError extends RewardsAdminState {
  final String message; const RewardsError(this.message);
  @override
  List<Object?> get props => [message];
}


