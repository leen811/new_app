import 'package:equatable/equatable.dart';
import '../../Data/Models/geofence_models.dart';

abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object?> get props => [];
}

class AttendanceInitRequested extends AttendanceEvent {}
class MockLocationChanged extends AttendanceEvent {
  final LocationPoint point;
  const MockLocationChanged(this.point);
  @override
  List<Object?> get props => [point];
}
class CheckInRequested extends AttendanceEvent {}
class CheckOutRequested extends AttendanceEvent {}
class BreakStartRequested extends AttendanceEvent {}
class BreakEndRequested extends AttendanceEvent {}
class TickWork extends AttendanceEvent {}
class TickBreak extends AttendanceEvent {}

// الاحتفاظ بالأحداث القديمة للتوافق العكسي
class AttendanceFabPressed extends AttendanceEvent {}
class BreakFabPressed extends AttendanceEvent {}


