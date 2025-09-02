import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../Data/Models/geofence_models.dart';

enum AttendanceStatus { ready, checkedIn, checkedOut }
enum BreakStatus { none, onBreak }

class AttendanceState extends Equatable {
  final AttendanceStatus status;
  final BreakStatus breakStatus;
  final bool geoRequired;
  final GeofenceSite? currentSite;
  final bool fabVisible;
  final Duration workDuration;
  final Duration breakDuration;
  final Duration totalWorkDuration; // إجمالي ساعات العمل (مع الاستراحات)
  final Duration pureWorkDuration; // إجمالي ساعات العمل (بدون استراحات)
  final DateTime? checkInAt;
  final DateTime? lastBreakStart; // وقت بداية آخر استراحة
  final Position? lastPosition;
  final String? lastAddress;
  final String? errorMessage;

  const AttendanceState({
    this.status = AttendanceStatus.ready,
    this.breakStatus = BreakStatus.none,
    this.geoRequired = true,
    this.currentSite,
    this.fabVisible = true,
    this.workDuration = Duration.zero,
    this.breakDuration = Duration.zero,
    this.totalWorkDuration = Duration.zero,
    this.pureWorkDuration = Duration.zero,
    this.checkInAt,
    this.lastBreakStart,
    this.lastPosition,
    this.lastAddress,
    this.errorMessage,
  });

  bool get canCheckIn => geoRequired ? currentSite != null : true;
  bool get isCheckedIn => status == AttendanceStatus.checkedIn;
  bool get isOnBreak => breakStatus == BreakStatus.onBreak;

  AttendanceState copyWith({
    AttendanceStatus? status,
    BreakStatus? breakStatus,
    bool? geoRequired,
    GeofenceSite? currentSite,
    bool? fabVisible,
    Duration? workDuration,
    Duration? breakDuration,
    Duration? totalWorkDuration,
    Duration? pureWorkDuration,
    DateTime? checkInAt,
    DateTime? lastBreakStart,
    Position? lastPosition,
    String? lastAddress,
    String? errorMessage,
  }) => AttendanceState(
        status: status ?? this.status,
        breakStatus: breakStatus ?? this.breakStatus,
        geoRequired: geoRequired ?? this.geoRequired,
        currentSite: currentSite ?? this.currentSite,
        fabVisible: fabVisible ?? this.fabVisible,
        workDuration: workDuration ?? this.workDuration,
        breakDuration: breakDuration ?? this.breakDuration,
        totalWorkDuration: totalWorkDuration ?? this.totalWorkDuration,
        pureWorkDuration: pureWorkDuration ?? this.pureWorkDuration,
        checkInAt: checkInAt ?? this.checkInAt,
        lastBreakStart: lastBreakStart ?? this.lastBreakStart,
        lastPosition: lastPosition ?? this.lastPosition,
        lastAddress: lastAddress ?? this.lastAddress,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        status, breakStatus, geoRequired, currentSite, fabVisible,
        workDuration, breakDuration, totalWorkDuration, pureWorkDuration,
        checkInAt, lastBreakStart, lastPosition, lastAddress, errorMessage
      ];
}


