import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

class GeoStamp extends Equatable {
  final double lat;
  final double lng;
  final String? address; // لو عندك geocoding
  const GeoStamp({required this.lat, required this.lng, this.address});

  String get display =>
      address ?? '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';

  @override
  List<Object?> get props => [lat, lng, address];
}

class AttendanceSession extends Equatable {
  final DateTime checkInAt;
  final GeoStamp inStamp;
  final DateTime? checkOutAt;
  final GeoStamp? outStamp;

  const AttendanceSession({
    required this.checkInAt,
    required this.inStamp,
    this.checkOutAt,
    this.outStamp,
  });

  AttendanceSession close({required DateTime at, required GeoStamp stamp}) {
    return AttendanceSession(
      checkInAt: checkInAt,
      inStamp: inStamp,
      checkOutAt: at,
      outStamp: stamp,
    );
  }

  @override
  List<Object?> get props => [
    checkInAt,
    inStamp.lat, inStamp.lng, inStamp.address,
    checkOutAt,
    outStamp?.lat, outStamp?.lng, outStamp?.address,
  ];
}

enum AttendanceStatus { ready, checkedIn }
enum BreakStatus { none, onBreak }

class AttendanceState extends Equatable {
  final AttendanceStatus status;        // ready / checkedIn
  final BreakStatus breakStatus;        // none / onBreak
  final bool isCheckedIn;
  final bool isOnBreak;
  final DateTime? checkInAt;
  final DateTime? lastBreakStart;
  final Duration workDuration;
  final Duration totalWorkDuration;
  final Duration pureWorkDuration;
  final Duration breakDuration;
  final Position? lastPosition;         // geolocator Position
  final String? lastAddress;
  final String? errorMessage;
  final List<AttendanceSession> sessions;

  const AttendanceState({
    this.status = AttendanceStatus.ready,
    this.breakStatus = BreakStatus.none,
    this.isCheckedIn = false,
    this.isOnBreak = false,
    this.checkInAt,
    this.lastBreakStart,
    this.workDuration = Duration.zero,
    this.totalWorkDuration = Duration.zero,
    this.pureWorkDuration = Duration.zero,
    this.breakDuration = Duration.zero,
    this.lastPosition,
    this.lastAddress,
    this.errorMessage,
    this.sessions = const [],
  });

  AttendanceState copyWith({
    AttendanceStatus? status,
    BreakStatus? breakStatus,
    bool? isCheckedIn,
    bool? isOnBreak,
    DateTime? checkInAt,
    bool clearCheckInAt = false,

    DateTime? lastBreakStart,
    bool clearLastBreakStart = false,

    Duration? workDuration,
    Duration? totalWorkDuration,
    Duration? pureWorkDuration,
    Duration? breakDuration,

    Position? lastPosition,
    bool clearLastPosition = false,

    String? lastAddress,
    bool clearLastAddress = false,

    String? errorMessage,
    bool clearErrorMessage = false,
    List<AttendanceSession>? sessions,
  }) {
    return AttendanceState(
      status: status ?? this.status,
      breakStatus: breakStatus ?? this.breakStatus,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      isOnBreak: isOnBreak ?? this.isOnBreak,
      checkInAt: clearCheckInAt ? null : (checkInAt ?? this.checkInAt),
      lastBreakStart: clearLastBreakStart ? null : (lastBreakStart ?? this.lastBreakStart),
      workDuration: workDuration ?? this.workDuration,
      totalWorkDuration: totalWorkDuration ?? this.totalWorkDuration,
      pureWorkDuration: pureWorkDuration ?? this.pureWorkDuration,
      breakDuration: breakDuration ?? this.breakDuration,
      lastPosition: clearLastPosition ? null : (lastPosition ?? this.lastPosition),
      lastAddress: clearLastAddress ? null : (lastAddress ?? this.lastAddress),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      sessions: sessions ?? this.sessions,
    );
  }

  @override
  List<Object?> get props => [
    status, breakStatus, isCheckedIn, isOnBreak,
    checkInAt, lastBreakStart,
    workDuration, totalWorkDuration, pureWorkDuration, breakDuration,
    // lastPosition,  // <- اشطبه من المقارنة (كائن كبير)
    lastAddress, errorMessage,
    sessions,
  ];
}