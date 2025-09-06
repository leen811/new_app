import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Data/Repositories/attendance_repository.dart';
import 'attendance_list_event.dart';
import 'attendance_list_state.dart';

class AttendanceListBloc extends Bloc<LoadPresence, AttendanceListState> {
  final AttendanceDataRepository repository;
  AttendanceListBloc(this.repository) : super(const AttendanceListInitial()) {
    on<LoadPresence>(_onLoad);
  }

  Future<void> _onLoad(LoadPresence event, Emitter<AttendanceListState> emit) async {
    emit(const AttendanceListLoading());
    try {
      final list = await repository.fetchTodayPresence(query: event.query, department: event.department);
      emit(AttendanceListLoaded(list: list, query: event.query ?? '', department: event.department ?? 'جميع الأقسام'));
    } catch (e) {
      emit(AttendanceListError(e.toString()));
    }
  }
}


