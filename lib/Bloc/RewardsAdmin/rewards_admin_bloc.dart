import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/rewards_admin_repository.dart';
import 'rewards_admin_event.dart';
import 'rewards_admin_state.dart';

class RewardsAdminBloc extends Bloc<RewardsAdminEvent, RewardsAdminState> {
  final RewardsAdminRepository repository;
  RewardsAdminBloc(this.repository) : super(const RewardsInitial()) {
    on<RewardsLoad>(_onLoad);
    on<RewardsChangeTab>(_onChangeTab);
    on<RewardsSearchChanged>(_onSearch);
    on<RewardsGrantSubmit>(_onGrantSubmit);
    on<RewardsQuickAmount>(_onQuick);
    on<RewardsSelectReason>(_onSelectReason);
    on<RewardsGrantGroup>(_onGrantGroup);
  }

  Future<void> _onLoad(RewardsLoad event, Emitter<RewardsAdminState> emit) async {
    emit(const RewardsLoading());
    try {
      final (summary, reasons) = await repository.fetchSummary();
      final balances = await repository.fetchBalances();
      final transactions = await repository.fetchTransactions();
      emit(RewardsLoaded(
        currentTab: 0,
        summary: summary,
        reasons: reasons,
        query: '',
        quickAmount: null,
        selectedReasonId: null,
        balances: balances,
        transactions: transactions,
      ));
    } catch (e) {
      emit(RewardsError(e.toString()));
    }
  }

  void _onChangeTab(RewardsChangeTab event, Emitter<RewardsAdminState> emit) {
    final s = state;
    if (s is RewardsLoaded) {
      emit(s.copyWith(currentTab: event.index));
    }
  }

  Future<void> _onSearch(RewardsSearchChanged event, Emitter<RewardsAdminState> emit) async {
    final s = state;
    if (s is RewardsLoaded) {
      final list = await repository.fetchBalances(query: event.query);
      emit(s.copyWith(query: event.query, balances: list));
    }
  }

  Future<void> _onGrantSubmit(RewardsGrantSubmit event, Emitter<RewardsAdminState> emit) async {
    final s = state;
    if (s is RewardsLoaded) {
      await repository.grantTokens(
        employeeId: event.employeeId,
        amount: event.amount,
        reason: event.reason,
        deduct: event.deduct,
      );
      final (summary, _) = await repository.fetchSummary();
      final balances = await repository.fetchBalances(query: s.query);
      final transactions = await repository.fetchTransactions();
      emit(s.copyWith(summary: summary, balances: balances, transactions: transactions));
    }
  }

  void _onQuick(RewardsQuickAmount event, Emitter<RewardsAdminState> emit) {
    final s = state;
    if (s is RewardsLoaded) emit(s.copyWith(quickAmount: event.value));
  }

  void _onSelectReason(RewardsSelectReason event, Emitter<RewardsAdminState> emit) {
    final s = state;
    if (s is RewardsLoaded) {
      emit(s.copyWith(selectedReasonId: event.reasonId));
      final r = s.reasons.firstWhere(
        (e) => e.id == event.reasonId,
        orElse: () => s.reasons.last,
      );
      if (r.points > 0) emit(s.copyWith(quickAmount: r.points));
    }
  }

  Future<void> _onGrantGroup(RewardsGrantGroup event, Emitter<RewardsAdminState> emit) async {
    final s = state;
    if (s is RewardsLoaded) {
      await repository.grantGroup(reasonId: event.reasonId);
      final (summary, _) = await repository.fetchSummary();
      final balances = await repository.fetchBalances(query: s.query);
      final transactions = await repository.fetchTransactions();
      emit(s.copyWith(summary: summary, balances: balances, transactions: transactions));
    }
  }
}


