import 'package:bloc/bloc.dart';
import 'dart:async';
import '../../Data/Repositories/meetings_repository.dart';
import '../../Data/Models/meetings_models.dart';
import 'meetings_event.dart';
import 'meetings_state.dart';

class MeetingsBloc extends Bloc<MeetingsEvent, MeetingsState> {
  final MeetingsRepository repository;
  int _tab = 0; // 0 upcoming, 1 completed, 2 archived
  String _q = '';
  // Debounce for availability checks
  Timer? _debounce;

  MeetingsBloc(this.repository) : super(MeetingsInitial()) {
    on<MeetingsLoad>(_onLoad);
    on<MeetingsChangeTab>(_onTab);
    on<MeetingsSearchChanged>(_onSearch);
    on<MeetingCreateSubmitted>(_onCreate);
    on<MeetingUpdateSubmitted>(_onUpdate);
    on<MeetingDelete>(_onDelete);
    // Scheduling
    on<ScheduleInit>(_onScheduleInit);
    on<ScheduleRoomChanged>(_onScheduleChanged);
    on<ScheduleDateTimeChanged>(_onScheduleChanged);
    on<ScheduleCheckAvailability>(_onScheduleCheck);
    on<ScheduleRequestSuggestions>(_onSuggestions);
  }

  MeetingStatus _mapTabToStatus(int i) {
    switch (i) {
      case 1:
        return MeetingStatus.completed;
      case 2:
        return MeetingStatus.archived;
      case 0:
      default:
        return MeetingStatus.upcoming;
    }
  }

  // --- Scheduling handlers ---
  Future<void> _onScheduleInit(ScheduleInit event, Emitter<MeetingsState> emit) async {
    // Load rooms
    final rooms = await repository.listRooms();
    if (state is MeetingsWithSchedule) {
      emit((state as MeetingsWithSchedule).copyWith(rooms: rooms));
    } else if (state is MeetingsLoaded) {
      final b = state as MeetingsLoaded;
      emit(MeetingsWithSchedule(currentTab: b.currentTab, kpis: b.kpis, items: b.items, query: b.query, rooms: rooms));
    } else {
      emit(const MeetingsWithSchedule(currentTab: 0, kpis: MeetingsKpis(scheduled: 0, completed: 0, totalMinutes: 0, participants: 0), items: [], query: '', rooms: []));
    }
  }

  Future<void> _onScheduleChanged(MeetingsEvent event, Emitter<MeetingsState> emit) async {
    final base = state is MeetingsWithSchedule
        ? state as MeetingsWithSchedule
        : (state is MeetingsLoaded
            ? MeetingsWithSchedule(currentTab: (state as MeetingsLoaded).currentTab, kpis: (state as MeetingsLoaded).kpis, items: (state as MeetingsLoaded).items, query: (state as MeetingsLoaded).query)
            : const MeetingsWithSchedule(currentTab: 0, kpis: MeetingsKpis(scheduled: 0, completed: 0, totalMinutes: 0, participants: 0), items: [], query: ''));
    String? roomId = base.selectedRoomId;
    DateTime? start = base.start;
    int duration = base.durationMinutes;
    if (event is ScheduleRoomChanged) roomId = event.roomId;
    if (event is ScheduleDateTimeChanged) { start = event.start; duration = event.durationMinutes; }
    final wantCheck = roomId != null && start != null && duration > 0;
    emit(base.copyWith(selectedRoomId: roomId, start: start, durationMinutes: duration, checking: wantCheck, availability: null));
    _debounce?.cancel();
    if (wantCheck) {
      _debounce = Timer(const Duration(milliseconds: 350), () => add(const ScheduleCheckAvailability()));
    }
  }

  Future<void> _onScheduleCheck(ScheduleCheckAvailability event, Emitter<MeetingsState> emit) async {
    final s = state is MeetingsWithSchedule ? state as MeetingsWithSchedule : null;
    if (s == null) return;
    if (s.selectedRoomId == null || s.start == null || s.durationMinutes <= 0) {
      emit(s.copyWith(checking: false));
      return;
    }
    final end = s.start!.add(Duration(minutes: s.durationMinutes));
    final avail = await repository.checkRoomAvailability(roomId: s.selectedRoomId!, start: s.start!, end: end);
    emit(s.copyWith(availability: avail, checking: false));
  }

  Future<void> _onSuggestions(ScheduleRequestSuggestions event, Emitter<MeetingsState> emit) async {
    final s = state is MeetingsWithSchedule ? state as MeetingsWithSchedule : null;
    if (s == null || s.selectedRoomId == null || s.start == null || s.durationMinutes <= 0) return;
    emit(s.copyWith(suggesting: true));
    final suggestions = await repository.suggestRoomSlots(
      roomId: s.selectedRoomId!,
      start: s.start!,
      durationMinutes: s.durationMinutes,
    );
    emit(s.copyWith(suggestions: suggestions, suggesting: false));
  }

  Future<void> _fetchAndEmit(Emitter<MeetingsState> emit, {bool showLoading = true}) async {
    if (showLoading) {
      emit(MeetingsLoading());
    }
    try {
      final (kpis, items) = await repository.fetch(q: _q, tab: _mapTabToStatus(_tab));
      // Preserve schedule overlay
      if (state is MeetingsWithSchedule) {
        final s = state as MeetingsWithSchedule;
        emit(MeetingsWithSchedule(
          currentTab: _tab,
          kpis: kpis,
          items: items,
          query: _q,
          rooms: s.rooms,
          selectedRoomId: s.selectedRoomId,
          start: s.start,
          durationMinutes: s.durationMinutes,
          availability: s.availability,
          suggestions: s.suggestions,
          checking: s.checking,
          suggesting: s.suggesting,
        ));
      } else {
        emit(MeetingsLoaded(currentTab: _tab, kpis: kpis, items: items, query: _q));
      }
    } catch (e) {
      emit(const MeetingsError('تعذر تحميل الاجتماعات'));
    }
  }

  Future<void> _onLoad(MeetingsLoad event, Emitter<MeetingsState> emit) async {
    _tab = 0;
    await _fetchAndEmit(emit, showLoading: true);
  }

  Future<void> _onTab(MeetingsChangeTab event, Emitter<MeetingsState> emit) async {
    _tab = event.index;
    await _fetchAndEmit(emit, showLoading: false);
  }

  Future<void> _onSearch(MeetingsSearchChanged event, Emitter<MeetingsState> emit) async {
    _q = event.query;
    await _fetchAndEmit(emit, showLoading: false);
  }

  Future<void> _onCreate(MeetingCreateSubmitted event, Emitter<MeetingsState> emit) async {
    try {
      await repository.create(event.draft);
      await _fetchAndEmit(emit);
    } catch (e) {
      emit(const MeetingsError('تعذر إنشاء الاجتماع'));
    }
  }

  Future<void> _onUpdate(MeetingUpdateSubmitted event, Emitter<MeetingsState> emit) async {
    try {
      await repository.update(event.id, event.patch);
      await _fetchAndEmit(emit);
    } catch (e) {
      emit(const MeetingsError('تعذر تحديث الاجتماع'));
    }
  }

  Future<void> _onDelete(MeetingDelete event, Emitter<MeetingsState> emit) async {
    try {
      await repository.delete(event.id);
      await _fetchAndEmit(emit);
    } catch (e) {
      emit(const MeetingsError('تعذر حذف الاجتماع'));
    }
  }
}


