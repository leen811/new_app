import 'package:bloc/bloc.dart';
import '../../Data/Repositories/meetings_repository.dart';
import '../../Data/Models/meetings_models.dart';
import 'employee_meetings_event.dart';
import 'employee_meetings_state.dart';

class MyMeetingsBloc extends Bloc<MyMeetingsEvent, MyMeetingsState> {
  final MeetingsRepository repository;
  final String userId;

  int _tab = 0; // 0 today | 1 upcoming | 2 completed
  String _q = '';

  MyMeetingsBloc({required this.repository, required this.userId}) : super(MyMeetingsInitial()) {
    on<MyMeetingsLoad>(_onLoad);
    on<MyMeetingsChangeTab>(_onTab);
    on<MyMeetingsSearchChanged>(_onSearch);
    on<MyMeetingsJoin>(_onJoin);
    on<MyMeetingsAddToCalendar>(_onAddToCalendar);
  }

  MeetingStatus _statusForTab(int i) {
    switch (i) {
      case 0:
        // Treat tab 0 as today's meetings; we will filter later by date.
        return MeetingStatus.upcoming;
      case 2:
        return MeetingStatus.completed;
      case 1:
      default:
        return MeetingStatus.upcoming;
    }
  }

  Future<void> _emitFetched(Emitter<MyMeetingsState> emit, {bool showLoading = true}) async {
    if (showLoading) emit(MyMeetingsLoading());
    try {
      final tabStatus = _statusForTab(_tab);
      final (kpis, list) = await repository.fetchForUser(userId: userId, q: _q, tab: tabStatus);
      // For "today" tab, filter to only today's date
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final items = _tab == 0
          ? list.where((m) => m.date.isAfter(startOfDay) && m.date.isBefore(endOfDay)).toList()
          : list;
      // Compute today count from all upcoming (ignore query) for accurate badge
      final upcomingAll = (await repository.fetchForUser(userId: userId, q: '', tab: MeetingStatus.upcoming)).$2;
      final todayCount = upcomingAll
          .where((m) => m.date.isAfter(startOfDay) && m.date.isBefore(endOfDay))
          .length;
      emit(MyMeetingsLoaded(currentTab: _tab, kpis: kpis, query: _q, items: items, todayCount: todayCount));
    } catch (e) {
      emit(const MyMeetingsError('تعذر تحميل الاجتماعات'));
    }
  }

  Future<void> _onLoad(MyMeetingsLoad event, Emitter<MyMeetingsState> emit) async {
    _tab = 0;
    await _emitFetched(emit, showLoading: true);
  }

  Future<void> _onTab(MyMeetingsChangeTab event, Emitter<MyMeetingsState> emit) async {
    _tab = event.index;
    await _emitFetched(emit, showLoading: false);
  }

  Future<void> _onSearch(MyMeetingsSearchChanged event, Emitter<MyMeetingsState> emit) async {
    _q = event.q;
    await _emitFetched(emit, showLoading: false);
  }

  Future<void> _onJoin(MyMeetingsJoin event, Emitter<MyMeetingsState> emit) async {
    // UI layer will handle launching and snackbar via callback. Keep BLoC lean.
  }

  Future<void> _onAddToCalendar(MyMeetingsAddToCalendar event, Emitter<MyMeetingsState> emit) async {
    // Optional: integrate with calendar services if added later.
  }
}


