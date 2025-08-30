import 'package:bloc/bloc.dart';
import 'perf360_event.dart';
import 'perf360_state.dart';
import '../../Data/Repositories/perf360_repository.dart';
import '../../Data/Models/360/eval_user.dart';
import '../../Data/Models/360/eval_summary.dart';
import '../../Data/Models/360/eval_pending.dart';
import '../../Data/Models/360/eval_category.dart';
import '../../Data/Models/360/eval_request.dart';
import '../../Data/Models/360/eval_result_row.dart';

class Perf360Bloc extends Bloc<Perf360Event, Perf360State> {
  final IPerf360Repository repository;
  Perf360Bloc(this.repository) : super(Perf360Loading()) {
    on<Perf360Opened>(_open);
    on<Perf360Refreshed>(_refresh);
    on<Perf360TabChanged>((e, emit) => _update(emit, state, tabIndex: e.index));
    on<Perf360StartPending>(_startPending);
    on<Perf360FormKindChanged>(_formKind);
    on<Perf360FormTargetChanged>(_formTarget);
    on<Perf360FormOverallChanged>(_formOverall);
    on<Perf360FormCategoryChanged>(_formCategory);
    on<Perf360FormSubmit>(_submit);
    on<Perf360ResultsOpened>(_openResults);
    on<Perf360AnalyticsOpened>(_openAnalytics);
  }

  Future<void> _open(Perf360Opened e, Emitter<Perf360State> emit) async {
    emit(Perf360Loading());
    await _loadAll(emit, setLoading: true);
  }

  Future<void> _refresh(Perf360Refreshed e, Emitter<Perf360State> emit) async {
    await _loadAll(emit, setLoading: false);
  }

  Future<void> _loadAll(Emitter<Perf360State> emit, {required bool setLoading}) async {
    try {
      final results = await Future.wait([
        repository.summary(),
        repository.pending(),
        repository.peers(),
      ]);
      final s = results[0] as Map<String, dynamic>;
      final me = EvalUser.fromJson(s['user'] as Map<String, dynamic>);
      final summary = EvalSummary.fromJson(s);
      final pending = List<Map<String, dynamic>>.from(results[1] as List).map((e) => EvalPending.fromJson(e)).toList();
      final peers = List<Map<String, dynamic>>.from(results[2] as List).map((e) => EvalUser.fromJson(e)).toList();
      final form = EvalRequest(kind: 'self', overall: 0.0, categories: _defaultCategories());
      emit(Perf360Success(tabIndex: 0, me: me, summary: summary, pending: pending, peers: peers, form: form, previewScore: 0));
    } catch (e) {
      emit(const Perf360Error('تعذر تحميل تقييم 360'));
    }
  }

  void _update(Emitter<Perf360State> emit, Perf360State current, {int? tabIndex, EvalRequest? form, bool? submitting}) {
    if (current is Perf360Success) {
      emit(current.copyWith(tabIndex: tabIndex, form: form, submitting: submitting));
    }
  }

  Future<void> _startPending(Perf360StartPending e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      final p = s.pending.firstWhere((x) => x.id == e.id);
      final form = EvalRequest(kind: p.kind, targetId: p.target.id, overall: 4.0, categories: _defaultCategories());
      _update(emit, s, tabIndex: 1, form: form);
    }
  }

  Future<void> _formKind(Perf360FormKindChanged e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      _update(emit, s, form: EvalRequest(kind: e.kind, targetId: null, overall: s.form.overall, categories: s.form.categories));
    }
  }

  Future<void> _formTarget(Perf360FormTargetChanged e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      _update(emit, s, form: EvalRequest(kind: s.form.kind, targetId: e.userId, overall: s.form.overall, categories: s.form.categories));
    }
  }

  Future<void> _formOverall(Perf360FormOverallChanged e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      final form = EvalRequest(kind: s.form.kind, targetId: s.form.targetId, overall: e.overall, categories: s.form.categories);
      emit(s.copyWith(form: form, previewScore: _computePreview(form)));
    }
  }

  Future<void> _formCategory(Perf360FormCategoryChanged e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      final updated = s.form.categories.map((c) => c.name == e.name ? EvalCategory(name: c.name, weightPct: c.weightPct, score: e.score) : c).toList();
      final form = EvalRequest(kind: s.form.kind, targetId: s.form.targetId, overall: s.form.overall, categories: updated);
      emit(s.copyWith(form: form, previewScore: _computePreview(form)));
    }
  }

  Future<void> _submit(Perf360FormSubmit e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success) {
      _update(emit, s, submitting: true);
      try {
        await repository.submit(s.form.toJson());
        _update(emit, s, submitting: false);
      } catch (_) {
        _update(emit, s, submitting: false);
      }
    }
  }

  List<EvalCategory> _defaultCategories() => const [
        EvalCategory(name: 'القيادة', weightPct: 20),
        EvalCategory(name: 'التواصل', weightPct: 20),
        EvalCategory(name: 'العمل الجماعي', weightPct: 20),
        EvalCategory(name: 'الابتكار', weightPct: 15),
        EvalCategory(name: 'حل المشكلات', weightPct: 15),
        EvalCategory(name: 'الموثوقية', weightPct: 10),
      ];

  double _computePreview(EvalRequest form) {
    double detailed = 0;
    for (final c in form.categories) {
      final s = (c.score ?? 0);
      detailed += s * (c.weightPct / 100.0);
    }
    // Weighted average: 30% overall + detailed (assuming weights sum to 100)
    final overallW = 0.3;
    final detailW = 0.7;
    return form.overall * overallW + detailed * detailW;
  }

  Future<void> _openResults(Perf360ResultsOpened e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success && (s.results == null || s.results!.isEmpty)) {
      try {
        final list = await repository.getDetailedResults();
        final rows = list.map((e) => EvalResultRow.fromJson(Map<String, dynamic>.from(e))).toList();
        emit(s.copyWith(results: rows));
      } catch (_) {
        // ignore for mock
      }
    }
  }

  Future<void> _openAnalytics(Perf360AnalyticsOpened e, Emitter<Perf360State> emit) async {
    final s = state;
    if (s is Perf360Success && s.analytics == null && !s.isLoadingAnalytics) {
      emit(s.copyWith(isLoadingAnalytics: true));
      try {
        final payload = await repository.getAnalytics();
        emit(s.copyWith(analytics: payload, isLoadingAnalytics: false));
      } catch (_) {
        emit(s.copyWith(isLoadingAnalytics: false));
      }
    }
  }
}


