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
    const GeoSite(name: 'HQ', lat: 24.7136, lng: 46.6753, radiusM: 1000), // توسيع النطاق للاختبار
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
    on<ClearErrorMessage>(_onClearErrorMessage);
    // الاحتفاظ بالأحداث القديمة للتوافق العكسي
    on<AttendanceFabPressed>(_onFab);
    on<BreakFabPressed>(_onBreakFab);
  }

  @override
  Future<void> close() {
    print('🔄 AttendanceBloc closing, stopping all timers...');
    _workTimer?.cancel();
    _breakTimer?.cancel();
    _workTimer = null;
    _breakTimer = null;
    print('✅ All timers stopped, AttendanceBloc closed');
    return super.close();
  }

  Future<void> _onInit(AttendanceInitRequested event, Emitter<AttendanceState> emit) async {
    print('🚀 AttendanceBloc initialization started');
    
    try {
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
      
      emit(state.copyWith());
      print('✅ AttendanceBloc initialization completed');
    } catch (e) {
      print('❌ AttendanceBloc initialization failed: $e');
      // في حالة فشل التهيئة، استخدم إعدادات افتراضية
      emit(state.copyWith(
        errorMessage: null,
      ));
    }
  }

  Future<void> _onMockLocation(MockLocationChanged event, Emitter<AttendanceState> emit) async {
    emit(state.copyWith());
  }

  Future<void> _onFab(AttendanceFabPressed event, Emitter<AttendanceState> emit) async {
    try {
      final lp = await locationSource.getCurrent();
      if (state.status == AttendanceStatus.ready) {
        await attendanceRepository.checkIn(lat: lp.lat, lng: lp.lng);
        emit(state.copyWith(
          status: AttendanceStatus.checkedIn,
          isCheckedIn: true,
        ));
      } else if (state.status == AttendanceStatus.checkedIn) {
        await attendanceRepository.checkOut(lat: lp.lat, lng: lp.lng);
              emit(state.copyWith(
        status: AttendanceStatus.ready,
        isCheckedIn: false,
        isOnBreak: false,
        clearLastBreakStart: true,
        clearErrorMessage: true,
      ));
      }
    } catch (e) {
      print('❌ Error in _onFab: $e');
      emit(state.copyWith(errorMessage: 'LOCATION_ERROR'));
    }
  }

  Future<void> _onCheckIn(CheckInRequested event, Emitter<AttendanceState> emit) async {
    if (isClosed) return;
    if (state.isCheckedIn) return; // حارس لمنع إعادة التهيئة
    print('🟢 CheckInRequested');

    try {
      final lp = await _safeGetLatLng(); // << الآمن
      print('📍 Using lat/lng: ${lp.lat}, ${lp.lng}');

      if (!_insideAnySiteLatLng(lp.lat, lp.lng)) {
        emit(state.copyWith(errorMessage: 'OUT_OF_GEOFENCE'));
        return;
      }

      // أوقف أي تايمرات سابقة
      _breakTimer?.cancel();
      _workTimer?.cancel();

      // ابدأ تايمر العمل
      _workTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!isClosed) add(TickWork());
      });

      final now = DateTime.now();
      final inStamp = GeoStamp(
        lat: lp.lat,
        lng: lp.lng,
        // لو ما عندك عنوان جاهز، اعرض lat/lng كنص
        address: '${lp.lat.toStringAsFixed(5)}, ${lp.lng.toStringAsFixed(5)}',
      );

      final newSession = AttendanceSession(checkInAt: now, inStamp: inStamp);
      final updated = List<AttendanceSession>.from(state.sessions)..add(newSession);

      emit(state.copyWith(
        status: AttendanceStatus.checkedIn,
        isCheckedIn: true,
        isOnBreak: false,
        checkInAt: now,
        // ما في داعي نخزّن Position تبع geolocator
        lastAddress: inStamp.display,
        workDuration: Duration.zero,
        pureWorkDuration: Duration.zero,
        totalWorkDuration: Duration.zero,
        breakDuration: Duration.zero,
        sessions: updated,
        errorMessage: null,
      ));

      print('✅ Check-in successful');
    } catch (e) {
      print('❌ Check-in failed: $e');
      emit(state.copyWith(errorMessage: 'LOCATION_ERROR'));
    }
  }

  Future<void> _onCheckOut(CheckOutRequested event, Emitter<AttendanceState> emit) async {
    if (isClosed) return;
    print('🔴 CheckOutRequested');

    // أوقف التايمرات
    _workTimer?.cancel();
    _breakTimer?.cancel();

    try {
      final lp = await _safeGetLatLng(); // << الآمن
      final outStamp = GeoStamp(
        lat: lp.lat, lng: lp.lng,
        address: '${lp.lat.toStringAsFixed(5)}, ${lp.lng.toStringAsFixed(5)}',
      );
      final now = DateTime.now();

      final idx = state.sessions.lastIndexWhere((s) => s.checkOutAt == null);
      final updated = List<AttendanceSession>.from(state.sessions);
      if (idx != -1) {
        updated[idx] = updated[idx].close(at: now, stamp: outStamp);
      }

      emit(state.copyWith(
        status: AttendanceStatus.ready,
        isCheckedIn: false,
        isOnBreak: false,
        sessions: updated,
        clearLastBreakStart: true,
        errorMessage: null,
      ));

      print('✅ Check-out successful');
    } catch (e) {
      // حتى لو فشل الحصول على الموقع، سكّر الجلسة بعنوان "غير معروف"
      final idx = state.sessions.lastIndexWhere((s) => s.checkOutAt == null);
      final updated = List<AttendanceSession>.from(state.sessions);
      if (idx != -1) {
        updated[idx] = updated[idx].close(
          at: DateTime.now(),
          stamp: const GeoStamp(lat: 0, lng: 0, address: 'غير معروف'),
        );
      }
      emit(state.copyWith(
        status: AttendanceStatus.ready,
        isCheckedIn: false,
        isOnBreak: false,
        sessions: updated,
        clearLastBreakStart: true,
        errorMessage: 'LOCATION_ERROR',
      ));
    }
  }

  Future<void> _onBreakStart(BreakStartRequested event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    
    // احفظ وقت بداية الاستراحة
    final breakStartTime = DateTime.now();
    
    // أوقف تايمر العمل مؤقتاً
    _workTimer?.cancel();
    
    // أوقف أي تايمر بريك سابق قبل تشغيل جديد
    _breakTimer?.cancel();
    
    // ابدأ تايمر الاستراحة
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) {
        add(TickBreak());
      }
    });
    
    emit(state.copyWith(
      breakStatus: BreakStatus.onBreak,
      isOnBreak: true,
      lastBreakStart: breakStartTime,
    ));
    print('☕ Break started, work timer paused, break timer started');
  }

  Future<void> _onBreakEnd(BreakEndRequested event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    _breakTimer?.cancel();
    _workTimer?.cancel();

    // رجّع تايمر العمل
    _workTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) add(TickWork());
    });

    emit(state.copyWith(
      breakStatus: BreakStatus.none,
      isOnBreak: false,
      clearLastBreakStart: true, // ما نضيف مدة ثانية!
    ));
  }

  void _onTickWork(TickWork event, Emitter<AttendanceState> emit) {
    // تحقق من أن BLoC لم يتم إغلاقه
    if (isClosed) return;
    
    final oneSecond = const Duration(seconds: 1);
    emit(state.copyWith(
      workDuration: state.workDuration + oneSecond,
      totalWorkDuration: state.totalWorkDuration + oneSecond,
      pureWorkDuration: state.pureWorkDuration + oneSecond,
    ));
  }

  void _onTickBreak(TickBreak event, Emitter<AttendanceState> emit) {
    if (isClosed) return;
    const oneSecond = Duration(seconds: 1);
    emit(state.copyWith(
      breakDuration: state.breakDuration + oneSecond,
      totalWorkDuration: state.totalWorkDuration + oneSecond, // إذا بدك تحسب الاستراحة ضمن الإجمالي
    ));
  }

  Future<void> _onBreakFab(BreakFabPressed event, Emitter<AttendanceState> emit) async {
    if (state.status != AttendanceStatus.checkedIn) return;
    try {
      final lp = await locationSource.getCurrent();
      if (state.breakStatus == BreakStatus.none) {
        await attendanceRepository.breakStart(lat: lp.lat, lng: lp.lng);
        emit(state.copyWith(
          breakStatus: BreakStatus.onBreak,
          isOnBreak: true,
        ));
      } else {
        await attendanceRepository.breakStop(lat: lp.lat, lng: lp.lng);
        emit(state.copyWith(
          breakStatus: BreakStatus.none,
          isOnBreak: false,
        ));
      }
    } catch (e) {
      print('❌ Error in _onBreakFab: $e');
      emit(state.copyWith(errorMessage: 'LOCATION_ERROR'));
    }
  }

  GeofenceSite? _matchSite(LocationPoint lp) {
    for (final s in _sites) {
      if (s.type == 'circle' && s.center != null && s.radiusM != null) {
        final d = _haversineMeters(lp.lat, lp.lng, s.center!.lat, s.center!.lng);
        if (d <= s.radiusM!) return s;
      }
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

  Future<LocationPoint> _safeGetLatLng() async {
    try {
      final pos = await _getCurrentPosition()
          .timeout(const Duration(seconds: 4)); // مهلة قصيرة
      return LocationPoint(lat: pos.latitude, lng: pos.longitude);
    } catch (e) {
      // fallback آمن
      return await locationSource.getCurrent();
    }
  }

  double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }



  bool _insideAnySiteLatLng(double lat, double lng) {
    for (final site in allowedSites) {
      final d = _distanceMeters(lat, lng, site.lat, site.lng);
      if (d <= site.radiusM) return true;
    }
    return false;
  }

  void _onClearErrorMessage(ClearErrorMessage event, Emitter<AttendanceState> emit) {
    emit(state.copyWith(clearErrorMessage: true));
  }
}