import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/employee_home_repository.dart';
import 'employee_home_event.dart';
import 'employee_home_state.dart';

class EmployeeHomeBloc extends Bloc<EmployeeHomeEvent, EmployeeHomeState> {
  final IEmployeeHomeRepository repository;

  EmployeeHomeBloc({required this.repository}) : super(EmployeeHomeLoading()) {
    on<EmployeeHomeLoaded>(_onEmployeeHomeLoaded);
  }

  Future<void> _onEmployeeHomeLoaded(
    EmployeeHomeLoaded event,
    Emitter<EmployeeHomeState> emit,
  ) async {
    try {
      emit(EmployeeHomeLoading());
      final snapshot = await repository.fetch();
      emit(EmployeeHomeReady(snapshot));
    } catch (e) {
      emit(EmployeeHomeError(e.toString()));
    }
  }
}
