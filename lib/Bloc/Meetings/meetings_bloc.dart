import 'package:bloc/bloc.dart';
import '../../Data/Repositories/meetings_repository.dart';
import '../../Data/Models/meetings_models.dart';
import 'meetings_event.dart';
import 'meetings_state.dart';

class MeetingsBloc extends Bloc<MeetingsEvent, MeetingsState> {
  final MeetingsRepository repository;
  int _tab = 0; // 0 upcoming, 1 completed, 2 archived
  String _q = '';

  MeetingsBloc(this.repository) : super(MeetingsInitial()) {
    on<MeetingsLoad>(_onLoad);
    on<MeetingsChangeTab>(_onTab);
    on<MeetingsSearchChanged>(_onSearch);
    on<MeetingCreateSubmitted>(_onCreate);
    on<MeetingUpdateSubmitted>(_onUpdate);
    on<MeetingDelete>(_onDelete);
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

  Future<void> _fetchAndEmit(Emitter<MeetingsState> emit, {bool showLoading = true}) async {
    if (showLoading) {
      emit(MeetingsLoading());
    }
    try {
      final (kpis, items) = await repository.fetch(q: _q, tab: _mapTabToStatus(_tab));
      emit(MeetingsLoaded(currentTab: _tab, kpis: kpis, items: items, query: _q));
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


