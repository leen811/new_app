import 'package:bloc/bloc.dart';

import '../../Data/Repositories/payroll_admin_repository.dart';
import 'payroll_admin_event.dart';
import 'payroll_admin_state.dart';

class PayrollAdminBloc extends Bloc<AdminPayrollEvent, AdminPayrollState> {
  final PayrollAdminRepository repository;
  PayrollAdminBloc(this.repository) : super(AdminPayrollInitial()) {
    on<AdminPayrollLoad>(_onLoad);
    on<AdminEmployeesSearchChanged>(_onSearch);
    on<AdminEmployeesFilterChanged>(_onFilter);
    on<AdminChangeTab>(_onChangeTab);
  }

  Future<void> _onLoad(AdminPayrollLoad event, Emitter<AdminPayrollState> emit) async {
    emit(AdminPayrollLoading());
    try {
      final summary = await repository.fetchDashboard();
      final employees = await repository.fetchEmployees(query: '', filter: 'الكل');
      emit(AdminPayrollLoaded(
        currentTab: 0,
        summary: summary,
        query: '',
        filter: 'الكل',
        employees: employees,
      ));
    } catch (e) {
      emit(AdminPayrollError('تعذر تحميل البيانات'));
    }
  }

  Future<void> _onSearch(AdminEmployeesSearchChanged event, Emitter<AdminPayrollState> emit) async {
    final s = state;
    if (s is! AdminPayrollLoaded) return;
    try {
      final employees = await repository.fetchEmployees(query: event.query, filter: s.filter);
      emit(s.copyWith(query: event.query, employees: employees));
    } catch (_) {
      emit(AdminPayrollError('تعذر تحميل الموظفين'));
    }
  }

  Future<void> _onFilter(AdminEmployeesFilterChanged event, Emitter<AdminPayrollState> emit) async {
    final s = state;
    if (s is! AdminPayrollLoaded) return;
    try {
      final employees = await repository.fetchEmployees(query: s.query, filter: event.filter);
      emit(s.copyWith(filter: event.filter, employees: employees));
    } catch (_) {
      emit(AdminPayrollError('تعذر تحميل الموظفين'));
    }
  }

  void _onChangeTab(AdminChangeTab event, Emitter<AdminPayrollState> emit) {
    final s = state;
    if (s is! AdminPayrollLoaded) return;
    emit(s.copyWith(currentTab: event.index));
  }
}


