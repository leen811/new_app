import 'package:equatable/equatable.dart';
import '../../Data/Models/leave_models.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object?> get props => [];
}

// حالة التحميل
class LeaveLoading extends LeaveState {
  const LeaveLoading();
}

// حالة جاهزة
class LeaveReady extends LeaveState {
  final LeaveBalance balance;
  final List<LeaveRecord> leaveHistory;
  final List<PermissionRecord> permissionHistory;
  final bool isSubmittingLeave;
  final bool isSubmittingPermission;
  final String? errorMessage;
  final String? successMessage;

  const LeaveReady({
    required this.balance,
    required this.leaveHistory,
    required this.permissionHistory,
    this.isSubmittingLeave = false,
    this.isSubmittingPermission = false,
    this.errorMessage,
    this.successMessage,
  });

  LeaveReady copyWith({
    LeaveBalance? balance,
    List<LeaveRecord>? leaveHistory,
    List<PermissionRecord>? permissionHistory,
    bool? isSubmittingLeave,
    bool? isSubmittingPermission,
    String? errorMessage,
    String? successMessage,
  }) {
    return LeaveReady(
      balance: balance ?? this.balance,
      leaveHistory: leaveHistory ?? this.leaveHistory,
      permissionHistory: permissionHistory ?? this.permissionHistory,
      isSubmittingLeave: isSubmittingLeave ?? this.isSubmittingLeave,
      isSubmittingPermission: isSubmittingPermission ?? this.isSubmittingPermission,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        leaveHistory,
        permissionHistory,
        isSubmittingLeave,
        isSubmittingPermission,
        errorMessage,
        successMessage,
      ];
}

// حالة الخطأ
class LeaveError extends LeaveState {
  final String message;

  const LeaveError(this.message);

  @override
  List<Object> get props => [message];
}
