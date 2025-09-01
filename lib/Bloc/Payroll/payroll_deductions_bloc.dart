import 'package:flutter_bloc/flutter_bloc.dart';
import 'payroll_deductions_event.dart';
import 'payroll_deductions_state.dart';
import '../../Data/Repositories/payroll_repository.dart';
import '../../Data/Models/payroll_models.dart';

class PayrollDeductionsBloc extends Bloc<PayrollDeductionsEvent, PayrollDeductionsState> {
  final PayrollRepository _repo;

  PayrollDeductionsBloc(this._repo) : super(PayrollInitial()) {
    on<PayrollLoad>((event, emit) async {
      emit(PayrollLoading());
      try {
        final byMonthF = _repo.fetchByMonth(month: event.month, year: event.year);
        final detailsF = _repo.fetchDetailsByMonth(month: event.month, year: event.year);
        final historyF = _repo.fetchHistory(limit: 12);

        final byMonth = await byMonthF;
        final details = await detailsF;
        final history = await historyF;

        final (summary, breakdown) = byMonth;

        emit(PayrollLoaded(
          month: event.month,
          year: event.year,
          currentTab: 0,
          summary: summary,
          breakdown: breakdown,
          details: details,
          history: history,
        ));
      } catch (e) {
        emit(PayrollError(e.toString()));
      }
    });
    on<PayrollChangeTab>(_onChangeTab);
  }

  void _onChangeTab(PayrollChangeTab event, Emitter<PayrollDeductionsState> emit) {
    final s = state;
    if (s is PayrollLoaded) {
      emit(s.copyWith(currentTab: event.index));
    }
  }
}
