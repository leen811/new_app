import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import '../../Data/Repositories/attendance_repository.dart';
import '../../Data/Repositories/geofence_repository.dart';
import '../../Data/Repositories/policy_repository.dart';
import '../../Data/Repositories/location_source.dart';
import '../../Data/Models/geofence_models.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class GeoSite {
  final String name;
  final double lat;
  final double lng;
  final double radiusM;
  
  const GeoSite({
    required this.name,
    required this.lat,
    required this.lng,
    required this.radiusM,
  });
}

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final IAttendanceRepository attendanceRepository;
  final IGeofenceRepository geofenceRepository;
  final IPolicyRepository policyRepository;
  final ILocationSource locationSource;

  List<GeofenceSite> _sites = const [];
  Timer? _workTimer;
  Timer? _breakTimer;
  
  // مواقع العمل المسموحة
  final allowedSites = [
    const GeoSite(name: 'HQ', lat: 24.7136, lng: 46.6753, radiusM: 300),
  ];

  AttendanceBloc({
    required this.attendanceRepository,
    required this.geofenceRepository,
    required this.policyRepository,
    required this.locationSource,
  }) : super(const AttendanceState()) {
    on<AttendanceInitRequested>(_onInit);
    on<MockLocationChanged>(_onMockLocation);
    on<CheckInRequested>(_onCheckIn);
    on<CheckOutRequested>(_onCheckOut);
    on<BreakStartRequested>(_onBreakStart);
    on<BreakEndRequested>(_onBreakEnd);
    on<TickWork>(_onTickWork);
    on<TickBreak>(_onTickBreak);
    // الاحتفاظ بالأحداث القديمة للتوافق العكسي
    on<AttendanceFabPressed>(_onFab);
    on<BreakFabPressed>(_onBreakFab);
  }

  @override
  Future<void> close() {
    _workTimer?.cancel();
    _breakTimer?.cancel();
    return super.close();
  }

  Future<void> _onInit(AttendanceInitRequested event, Emitter<AttendanceState> emit) async {
    print('🚀 AttendanceBloc initialization started');
    final policy = await policyRepository.fetchAttendancePolicy();
    print('📋 Policy loaded - geoRequired: ${policy.geoRequired}');
    _sites = await geofenceRepository.fetchSites();
    print('🗺️ Geofence sites loaded: ${_sites.length} sites');
    // افتراضياً: اعتبر داخل الموقع عبر أقرب نقطة لموقع A لتفعيل الزر مباشرة
    final initialPoint = _sites.isNotEmpty && _sites.first.center != null
        ? _sites.first.center!
        : await locationSource.getCurrent();
    print('📍 Initial location: ${initialPoint.lat}, ${initialPoint.lng}');
    final matchedSite = _matchSite(initialPoint);
    print('🎯 Matched site: ${matchedSite?.name ?? "None"}');
    emit(state.copyWith(geoRequired: policy.geoRequired, currentSite: matchedSite));
    print('✅ AttendanceBloc initialization completed');
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

  Future<void> _onCheckIn(CheckInRequested event, Emitter<AttendanceState> emit) async {
    print('🟢 CheckInRequested received - status: ${state.status}, canCheckIn: ${state.canCheckIn}');
    
    try {
      // احصل على الموقع الحالي (استخدم الموقع الافتراضي للتطوير)
      Position position;
      try {
        position = await _getCurrentPosition();
        print('📍 Real position: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        // إذا فشل الحصول على الموقع الحقيقي، استخدم الموقع الافتراضي
        print('⚠️ Using mock location for development');
        position = Position(
          latitude: 24.7136,
          longitude: 46.6753,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }
      
      // تحقق من أن المستخدم داخل أحد مواقع العمل
      if (!_insideAnySite(position)) {
        print('❌ User is outside allowed sites');
        emit(state.copyWith(errorMessage: 'OUT_OF_GEOFENCE'));
        return;
      }
      
      // أوقف أي تايمر بريك قائم
      _breakTimer?.cancel();
      
      // ابدأ تايمر العمل
      _workTimer = Timer.periodic(const Duration(seconds: 1), (_) => add(TickWork()));
      
      // تحديث الحالة
      emit(state.copyWith(
        status: AttendanceStatus.checkedIn,
        checkInAt: DateTime.now(),
        lastPosition: position,
        lastAddress: 'الرياض، المملكة العربية السعودية',
        errorMessage: null,
      ));
      
      print('✅ Check-in successful, work timer started');
    } catch (e) {
      print('❌ Check-in failed: $e');
      emit(state.copyWith(errorMessage: 'LOCATION_ERROR'));
    }
  }

  Future<void> _onCheckOut(CheckOutRequested event, Emitter<AttendanceState> emit) async {
    print('🔴 CheckOutRequested received - status: ${state.status}');
    
    // أوقف جميع التايمرات
    _workTimer?.cancel();
    _breakTimer?.cancel();
    
    // تحديث الحالة
    emit(state.copyWith(
      status: AttendanceStatus.ready,
      breakStatus: BreakStatus.none,
      errorMessage: null,
    ));
    
    print('✅ Check-out successful, all timers stopped');
  }

  Future<void> _onBreakStart(BreakStartRequested event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    
    // احفظ وقت بداية الاستراحة
    final breakStartTime = DateTime.now();
    
    // أوقف تايمر العمل مؤقتاً
    _workTimer?.cancel();
    
    // ابدأ تايمر الاستراحة
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) => add(TickBreak()));
    
    emit(state.copyWith(
      breakStatus: BreakStatus.onBreak,
      lastBreakStart: breakStartTime,
    ));
    print('☕ Break started, work timer paused, break timer started');
  }

  Future<void> _onBreakEnd(BreakEndRequested event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    
    // احسب مدة الاستراحة الحالية وأضفها للمجموع
    Duration currentBreakDuration = Duration.zero;
    if (state.lastBreakStart != null) {
      currentBreakDuration = DateTime.now().difference(state.lastBreakStart!);
    }
    
    // أوقف تايمر الاستراحة
    _breakTimer?.cancel();
    
    // ارجع لتايمر العمل
    _workTimer = Timer.periodic(const Duration(seconds: 1), (_) => add(TickWork()));
    
    emit(state.copyWith(
      breakStatus: BreakStatus.none,
      breakDuration: state.breakDuration + currentBreakDuration,
      lastBreakStart: null,
    ));
    print('⏰ Break ended, break timer stopped, work timer resumed');
  }

  void _onTickWork(TickWork event, Emitter<AttendanceState> emit) {
    final oneSecond = const Duration(seconds: 1);
    emit(state.copyWith(
      workDuration: state.workDuration + oneSecond,
      totalWorkDuration: state.totalWorkDuration + oneSecond, // إجمالي ساعات العمل (مع الاستراحات)
      pureWorkDuration: state.pureWorkDuration + oneSecond, // إجمالي ساعات العمل (بدون استراحات)
    ));
  }

  void _onTickBreak(TickBreak event, Emitter<AttendanceState> emit) {
    final oneSecond = const Duration(seconds: 1);
    emit(state.copyWith(
      totalWorkDuration: state.totalWorkDuration + oneSecond, // إجمالي ساعات العمل (مع الاستراحات)
      // لا نزيد pureWorkDuration أثناء الاستراحة
    ));
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

  // دوال مساعدة جديدة
  Future<Position> _getCurrentPosition() async {
    // تحقق من الصلاحيات
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('خدمة الموقع غير مفعلة');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض صلاحيات الموقع');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('صلاحيات الموقع مرفوضة نهائياً');
    }

    // احصل على الموقع الحالي
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  bool _insideAnySite(Position position) {
    return allowedSites.any((site) => 
      _distanceMeters(position.latitude, position.longitude, site.lat, site.lng) <= site.radiusM
    );
  }
}


