import 'package:equatable/equatable.dart';
import '../../Data/Models/attendance_models.dart';

abstract class AttendanceListState extends Equatable {
  const AttendanceListState();
  @override
  List<Object?> get props => [];
}

class AttendanceListInitial extends AttendanceListState { const AttendanceListInitial(); }
class AttendanceListLoading extends AttendanceListState { const AttendanceListLoading(); }

class AttendanceListLoaded extends AttendanceListState {
  final List<EmployeePresence> list;
  final String query;
  final String department;
  final String presence; // 'all' | 'present' | 'absent'
  const AttendanceListLoaded({required this.list, required this.query, required this.department, this.presence = 'all'});
  @override
  List<Object?> get props => [list, query, department, presence];
}

class AttendanceListError extends AttendanceListState {
  final String message; const AttendanceListError(this.message);
  @override
  List<Object?> get props => [message];
}


