import 'package:bloc/bloc.dart';
import 'dart:math';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Data/Repositories/geofence_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/location_source.dart';
import '../../Data/Models/geofence_models.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final IAttendanceRepository attendanceRepository;
  final IGeofenceRepository geofenceRepository;
  final IPolicyRepository policyRepository;
  final ILocationSource locationSource;

  List<GeofenceSite> _sites = const [];

  AttendanceBloc({
    required this.attendanceRepository,
    required this.geofenceRepository,
    required this.policyRepository,
    required this.locationSource,
  }) : super(const AttendanceState()) {
    on<AttendanceInitRequested>(_onInit);
    on<MockLocationChanged>(_onMockLocation);
    on<AttendanceFabPressed>(_onFab);
    on<BreakFabPressed>(_onBreakFab);
  }

  Future<void> _onInit(AttendanceInitRequested event, Emitter<AttendanceState> emit) async {
    final policy = await policyRepository.fetchAttendancePolicy();
    _sites = await geofenceRepository.fetchSites();
    // افتراضياً: اعتبر داخل الموقع عبر أقرب نقطة لموقع A لتفعيل الزر مباشرة
    final initialPoint = _sites.isNotEmpty && _sites.first.center != null
        ? _sites.first.center!
        : await locationSource.getCurrent();
    emit(state.copyWith(geoRequired: policy.geoRequired, currentSite: _matchSite(initialPoint)));
  }

  Future<void> _onMockLocation(MockLocationChanged event, Emitter<AttendanceState> emit) async {
    emit(state.copyWith(currentSite: _matchSite(event.point)));
  }

  Future<void> _onFab(AttendanceFabPressed event, Emitter<AttendanceState> emit) async {
    final lp = await locationSource.getCurrent();
    if (state.status == AttendanceStatus.ready && state.canCheckIn) {
      await attendanceRepository.checkIn(lat: lp.lat, lng: lp.lng);
      emit(state.copyWith(status: AttendanceStatus.checkedIn));
    } else if (state.status == AttendanceStatus.checkedIn) {
      await attendanceRepository.checkOut(lat: lp.lat, lng: lp.lng);
      // بعد الانصراف يعود إلى وضع الاستعداد للسماح بتسجيل حضور مرة أخرى
      emit(state.copyWith(status: AttendanceStatus.ready, breakStatus: BreakStatus.none));
    }
  }

  Future<void> _onBreakFab(BreakFabPressed event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    final lp = await locationSource.getCurrent();
    if (state.breakStatus == BreakStatus.none) {
      await attendanceRepository.breakStart(lat: lp.lat, lng: lp.lng);
      emit(state.copyWith(breakStatus: BreakStatus.onBreak));
    } else {
      await attendanceRepository.breakStop(lat: lp.lat, lng: lp.lng);
      emit(state.copyWith(breakStatus: BreakStatus.none));
    }
  }

  GeofenceSite? _matchSite(LocationPoint lp) {
    for (final s in _sites) {
      if (s.type == 'circle' && s.center != null && s.radiusM != null) {
        final d = _haversineMeters(lp.lat, lp.lng, s.center!.lat, s.center!.lng);
        if (d <= s.radiusM!) return s;
      }
      // polygon matching can be added later; for mock suffice with circle
    }
    return null;
  }

  double _haversineMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000.0; // meters
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        (sin(dLat / 2) * sin(dLat / 2)) + cos(_toRad(lat1)) * cos(_toRad(lat2)) * (sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRad(double deg) => deg * 3.141592653589793 / 180.0;
}


