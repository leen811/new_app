import 'package:equatable/equatable.dart';
import '../../Data/Models/360/eval_user.dart';
import '../../Data/Models/360/eval_summary.dart';
import '../../Data/Models/360/eval_pending.dart';
import '../../Data/Models/360/eval_request.dart';
import '../../Data/Models/360/eval_result_row.dart';
import '../../Data/Models/360/analytics_payload.dart';

abstract class Perf360State extends Equatable {
  const Perf360State();
  @override
  List<Object?> get props => [];
}

class Perf360Loading extends Perf360State {}
class Perf360Error extends Perf360State { final String message; const Perf360Error(this.message); @override List<Object?> get props => [message]; }
class Perf360Success extends Perf360State {
  final int tabIndex;
  final EvalUser me;
  final EvalSummary summary;
  final List<EvalPending> pending;
  final List<EvalUser> peers;
  final EvalRequest form;
  final double previewScore;
  final List<EvalResultRow>? results;
  final bool isLoadingAnalytics;
  final AnalyticsPayload? analytics;
  final bool submitting;
  final bool refreshing;
  const Perf360Success({required this.tabIndex, required this.me, required this.summary, required this.pending, required this.peers, required this.form, required this.previewScore, this.results, this.isLoadingAnalytics=false, this.analytics, this.submitting=false, this.refreshing=false});
  Perf360Success copyWith({int? tabIndex, EvalUser? me, EvalSummary? summary, List<EvalPending>? pending, List<EvalUser>? peers, EvalRequest? form, double? previewScore, List<EvalResultRow>? results, bool? isLoadingAnalytics, AnalyticsPayload? analytics, bool? submitting, bool? refreshing}) =>
      Perf360Success(tabIndex: tabIndex ?? this.tabIndex, me: me ?? this.me, summary: summary ?? this.summary, pending: pending ?? this.pending, peers: peers ?? this.peers, form: form ?? this.form, previewScore: previewScore ?? this.previewScore, results: results ?? this.results, isLoadingAnalytics: isLoadingAnalytics ?? this.isLoadingAnalytics, analytics: analytics ?? this.analytics, submitting: submitting ?? this.submitting, refreshing: refreshing ?? this.refreshing);
  @override
  List<Object?> get props => [tabIndex, me, summary, pending, peers, form, previewScore, results, isLoadingAnalytics, analytics, submitting, refreshing];
}


