import 'package:equatable/equatable.dart';
import '../../Data/Models/geofence_models.dart';

enum AttendanceStatus { ready, checkedIn, checkedOut }
enum BreakStatus { none, onBreak }

class AttendanceState extends Equatable {
  final AttendanceStatus status;
  final BreakStatus breakStatus;
  final bool geoRequired;
  final GeofenceSite? currentSite;
  final bool fabVisible;

  const AttendanceState({
    this.status = AttendanceStatus.ready,
    this.breakStatus = BreakStatus.none,
    this.geoRequired = true,
    this.currentSite,
    this.fabVisible = true,
  });

  bool get canCheckIn => geoRequired ? currentSite != null : true;

  AttendanceState copyWith({
    AttendanceStatus? status,
    BreakStatus? breakStatus,
    bool? geoRequired,
    GeofenceSite? currentSite,
    bool? fabVisible,
  }) => AttendanceState(
        status: status ?? this.status,
        breakStatus: breakStatus ?? this.breakStatus,
        geoRequired: geoRequired ?? this.geoRequired,
        currentSite: currentSite ?? this.currentSite,
        fabVisible: fabVisible ?? this.fabVisible,
      );

  @override
  List<Object?> get props => [status, breakStatus, geoRequired, currentSite, fabVisible];
}


