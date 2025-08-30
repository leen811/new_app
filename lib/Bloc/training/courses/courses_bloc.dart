import 'package:bloc/bloc.dart';
import 'courses_event.dart';
import 'courses_state.dart';
import '../../../Data/Repositories/training_repository.dart';
import '../../../Data/Models/course_item.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final ITrainingRepository repository;
  CoursesBloc(this.repository) : super(CoursesLoading()) {
    on<CoursesOpened>(_open);
    on<FilterChanged>(_filter);
    on<LoadMore>(_more);
    on<BookmarkToggled>(_toggle);
  }

  Future<void> _open(CoursesOpened e, Emitter<CoursesState> emit) async {
    emit(CoursesLoading());
    await _loadPage(emit, category: e.category, page: 1, reset: true);
  }

  Future<void> _filter(FilterChanged e, Emitter<CoursesState> emit) async {
    await _loadPage(emit, category: e.category, page: 1, reset: true);
  }

  Future<void> _more(LoadMore e, Emitter<CoursesState> emit) async {
    final s = state;
    if (s is CoursesSuccess && s.nextPage != null && !s.loadingMore) {
      emit(s.copyWith(loadingMore: true));
      await _loadPage(emit, category: s.category, page: s.nextPage!, reset: false, previous: s.items);
    }
  }

  Future<void> _toggle(BookmarkToggled e, Emitter<CoursesState> emit) async {
    final s = state;
    if (s is CoursesSuccess) {
      await repository.toggleBookmark(e.id);
      final updated = s.items.map((c) => c.id == e.id ? CourseItem.fromJson({..._toJson(c), 'isBookmarked': !c.isBookmarked}) : c).toList();
      emit(s.copyWith(items: updated));
    }
  }

  Future<void> _loadPage(Emitter<CoursesState> emit, {required String category, required int page, required bool reset, List<CourseItem>? previous}) async {
    final key = _normalizeCategory(category);
    final res = await repository.courses(category: key, page: page);
    final items = List<Map<String, dynamic>>.from(res['items'] as List).map((e) => CourseItem.fromJson(e)).toList();
    final next = res['nextPage'] as int?;
    if (reset) {
      emit(CoursesSuccess(items: items, category: category, nextPage: next, loadingMore: false));
    } else {
      final merged = <CourseItem>[...(previous ?? <CourseItem>[]), ...items];
      emit(CoursesSuccess(items: merged, category: category, nextPage: next, loadingMore: false));
    }
  }

  String _normalizeCategory(String category) {
    final c = category.trim();
    // Pass-through if already a normalized key
    const keys = {
      'all',
      'management',
      'technology',
      'soft',
      'engineering',
      'productivity',
    };
    if (keys.contains(c)) return c;
    if (c == 'all' || c.startsWith('جميع')) return 'all';
    if (c.contains('الإدارة')) return 'management';
    if (c.contains('التكنولوجيا')) return 'technology';
    if (c.contains('الناعمة')) return 'soft';
    if (c.contains('التقني')) return 'engineering';
    if (c.contains('الإنتاجية')) return 'productivity';
    return 'all';
  }

  Map<String, dynamic> _toJson(CourseItem c) => {
        'id': c.id,
        'title': c.title,
        'provider': c.provider,
        'priceLabel': c.priceLabel,
        'hours': c.hours,
        'level': c.level,
        'rating': c.rating,
        'ratingCount': c.ratingCount,
        'matchPct': c.matchPct,
        'tags': c.tags,
        'reason': c.reason,
        'startHijri': c.startHijri,
        'imageUrl': c.imageUrl,
        'isBookmarked': c.isBookmarked,
      };
}


