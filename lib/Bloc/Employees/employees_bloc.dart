import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/employees_repository.dart';
import '../../Data/Models/employee_models.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository repository;

  String _query = '';
  String _department = 'جميع الأقسام';
  EmployeeStatus? _status;

  EmployeesBloc(this.repository) : super(const EmployeesInitial()) {
    on<EmployeesLoad>(_onLoad);
    on<EmployeesQueryChanged>(_onQueryChanged);
    on<EmployeesDepartmentChanged>(_onDepartmentChanged);
    on<EmployeesStatusChanged>(_onStatusChanged);
  }

  Future<void> _fetch(Emitter<EmployeesState> emit) async {
    emit(const EmployeesLoading());
    try {
      final (summary, list) = await repository.fetch(
        query: _query,
        department: _department,
        status: _status,
      );
      emit(EmployeesLoaded(
        query: _query,
        department: _department,
        status: _status,
        summary: summary,
        list: list,
      ));
    } catch (e) {
      emit(EmployeesError(e.toString()));
    }
  }

  Future<void> _onLoad(EmployeesLoad event, Emitter<EmployeesState> emit) async {
    await _fetch(emit);
  }

  Future<void> _onQueryChanged(EmployeesQueryChanged event, Emitter<EmployeesState> emit) async {
    _query = event.query;
    await _fetch(emit);
  }

  Future<void> _onDepartmentChanged(EmployeesDepartmentChanged event, Emitter<EmployeesState> emit) async {
    _department = event.department ?? 'جميع الأقسام';
    await _fetch(emit);
  }

  Future<void> _onStatusChanged(EmployeesStatusChanged event, Emitter<EmployeesState> emit) async {
    _status = event.status;
    await _fetch(emit);
  }
}


