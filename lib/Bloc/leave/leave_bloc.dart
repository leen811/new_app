import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'leave_event.dart';
import 'leave_state.dart';
import '../../Data/Models/leave_models.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  LeaveBloc() : super(const LeaveLoading()) {
    on<LeaveDataLoaded>(_onDataLoaded);
    on<LeaveRequestSubmitted>(_onLeaveRequestSubmitted);
    on<PermissionRequestSubmitted>(_onPermissionRequestSubmitted);
    on<LeaveBalanceUpdated>(_onBalanceUpdated);
    on<LeaveHistoryUpdated>(_onLeaveHistoryUpdated);
    on<PermissionHistoryUpdated>(_onPermissionHistoryUpdated);
    on<LeaveFormReset>(_onFormReset);
  }

  Future<void> _onDataLoaded(
    LeaveDataLoaded event,
    Emitter<LeaveState> emit,
  ) async {
    try {
      // TODO: استبدال البيانات الوهمية ببيانات حقيقية من API
      final balance = const LeaveBalance(
        annual: 21,
        sick: 5,
        emergency: 3,
      );

      final leaveHistory = [
        LeaveRecord(
          id: '1',
          type: LeaveType.annual,
          startDate: DateTime(2024, 1, 15),
          endDate: DateTime(2024, 1, 17),
          days: 3,
          reason: 'رحلة عائلية',
          status: RequestStatus.approved,
          submittedAt: DateTime(2024, 1, 10),
        ),
        LeaveRecord(
          id: '2',
          type: LeaveType.sick,
          startDate: DateTime(2024, 2, 5),
          endDate: DateTime(2024, 2, 5),
          days: 1,
          reason: 'مرض',
          status: RequestStatus.pending,
          submittedAt: DateTime(2024, 2, 4),
        ),
      ];

      final permissionHistory = [
        PermissionRecord(
          id: '1',
          type: PermissionType.earlyLeave,
          date: DateTime(2024, 1, 20),
          from: const TimeOfDay(hour: 14, minute: 0),
          to: const TimeOfDay(hour: 16, minute: 0),
          duration: const Duration(hours: 2),
          reason: 'موعد طبي',
          status: RequestStatus.approved,
          submittedAt: DateTime(2024, 1, 19),
        ),
      ];

      emit(LeaveReady(
        balance: balance,
        leaveHistory: leaveHistory,
        permissionHistory: permissionHistory,
      ));
    } catch (e) {
      emit(LeaveError('حدث خطأ في تحميل البيانات: ${e.toString()}'));
    }
  }

  Future<void> _onLeaveRequestSubmitted(
    LeaveRequestSubmitted event,
    Emitter<LeaveState> emit,
  ) async {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      
      emit(currentState.copyWith(
        isSubmittingLeave: true,
        errorMessage: null,
        successMessage: null,
      ));

      try {
        // TODO: إرسال الطلب إلى API
        await Future.delayed(const Duration(seconds: 2)); // محاكاة API call

        // إضافة الطلب الجديد إلى التاريخ
        final newRecord = LeaveRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: event.request.type,
          startDate: event.request.startDate,
          endDate: event.request.endDate,
          days: event.request.days,
          reason: event.request.reason,
          status: RequestStatus.pending,
          submittedAt: DateTime.now(),
        );

        final updatedHistory = [newRecord, ...currentState.leaveHistory];

        emit(currentState.copyWith(
          leaveHistory: updatedHistory,
          isSubmittingLeave: false,
          successMessage: 'تم إرسال طلب الإجازة بنجاح',
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSubmittingLeave: false,
          errorMessage: 'فشل في إرسال طلب الإجازة: ${e.toString()}',
        ));
      }
    }
  }

  Future<void> _onPermissionRequestSubmitted(
    PermissionRequestSubmitted event,
    Emitter<LeaveState> emit,
  ) async {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      
      emit(currentState.copyWith(
        isSubmittingPermission: true,
        errorMessage: null,
        successMessage: null,
      ));

      try {
        // TODO: إرسال الطلب إلى API
        await Future.delayed(const Duration(seconds: 2)); // محاكاة API call

        // إضافة الطلب الجديد إلى التاريخ
        final newRecord = PermissionRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: event.request.type,
          date: event.request.date,
          from: event.request.from,
          to: event.request.to,
          duration: event.request.duration,
          reason: event.request.reason,
          status: RequestStatus.pending,
          submittedAt: DateTime.now(),
        );

        final updatedHistory = [newRecord, ...currentState.permissionHistory];

        emit(currentState.copyWith(
          permissionHistory: updatedHistory,
          isSubmittingPermission: false,
          successMessage: 'تم إرسال طلب الاستئذان بنجاح',
        ));
      } catch (e) {
        emit(currentState.copyWith(
          isSubmittingPermission: false,
          errorMessage: 'فشل في إرسال طلب الاستئذان: ${e.toString()}',
        ));
      }
    }
  }

  void _onBalanceUpdated(
    LeaveBalanceUpdated event,
    Emitter<LeaveState> emit,
  ) {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      emit(currentState.copyWith(balance: event.balance));
    }
  }

  void _onLeaveHistoryUpdated(
    LeaveHistoryUpdated event,
    Emitter<LeaveState> emit,
  ) {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      emit(currentState.copyWith(leaveHistory: event.history));
    }
  }

  void _onPermissionHistoryUpdated(
    PermissionHistoryUpdated event,
    Emitter<LeaveState> emit,
  ) {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      emit(currentState.copyWith(permissionHistory: event.history));
    }
  }

  void _onFormReset(
    LeaveFormReset event,
    Emitter<LeaveState> emit,
  ) {
    if (state is LeaveReady) {
      final currentState = state as LeaveReady;
      emit(currentState.copyWith(
        errorMessage: null,
        successMessage: null,
      ));
    }
  }
}
