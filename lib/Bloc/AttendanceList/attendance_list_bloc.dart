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
      // فلترة حسب الحضور
      final filtered = switch (event.presence) {
        'present' => list.where((e) => e.isCheckedIn).toList(),
        'absent' => list.where((e) => !e.isCheckedIn).toList(),
        _ => list,
      };
      emit(AttendanceListLoaded(list: filtered, query: event.query ?? '', department: event.department ?? 'جميع الأقسام', presence: event.presence));
    } catch (e) {
      emit(AttendanceListError(e.toString()));
    }
  }
}


