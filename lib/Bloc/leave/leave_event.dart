import 'package:equatable/equatable.dart';
import '../../Data/Models/leave_models.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

// تحميل البيانات الأولية
class LeaveDataLoaded extends LeaveEvent {
  const LeaveDataLoaded();
}

// إرسال طلب إجازة
class LeaveRequestSubmitted extends LeaveEvent {
  final LeaveRequest request;

  const LeaveRequestSubmitted(this.request);

  @override
  List<Object> get props => [request];
}

// إرسال طلب استئذان
class PermissionRequestSubmitted extends LeaveEvent {
  final PermissionRequest request;

  const PermissionRequestSubmitted(this.request);

  @override
  List<Object> get props => [request];
}

// تحديث رصيد الإجازات
class LeaveBalanceUpdated extends LeaveEvent {
  final LeaveBalance balance;

  const LeaveBalanceUpdated(this.balance);

  @override
  List<Object> get props => [balance];
}

// تحديث تاريخ الإجازات
class LeaveHistoryUpdated extends LeaveEvent {
  final List<LeaveRecord> history;

  const LeaveHistoryUpdated(this.history);

  @override
  List<Object> get props => [history];
}

// تحديث تاريخ الاستئذانات
class PermissionHistoryUpdated extends LeaveEvent {
  final List<PermissionRecord> history;

  const PermissionHistoryUpdated(this.history);

  @override
  List<Object> get props => [history];
}

// إعادة تعيين النموذج
class LeaveFormReset extends LeaveEvent {
  const LeaveFormReset();
}
