import 'package:equatable/equatable.dart';

abstract class Perf360Event extends Equatable {
  const Perf360Event();
  @override
  List<Object?> get props => [];
}

class Perf360Opened extends Perf360Event {}
class Perf360TabChanged extends Perf360Event { final int index; const Perf360TabChanged(this.index); @override List<Object?> get props => [index]; }
class Perf360Refreshed extends Perf360Event {}
class Perf360StartPending extends Perf360Event { final String id; const Perf360StartPending(this.id); @override List<Object?> get props => [id]; }
class Perf360FormKindChanged extends Perf360Event { final String kind; const Perf360FormKindChanged(this.kind); @override List<Object?> get props => [kind]; }
class Perf360FormTargetChanged extends Perf360Event { final String userId; const Perf360FormTargetChanged(this.userId); @override List<Object?> get props => [userId]; }
class Perf360FormOverallChanged extends Perf360Event { final double overall; const Perf360FormOverallChanged(this.overall); @override List<Object?> get props => [overall]; }
class Perf360FormCategoryChanged extends Perf360Event { final String name; final double score; const Perf360FormCategoryChanged(this.name, this.score); @override List<Object?> get props => [name, score]; }
class Perf360FormNotesChanged extends Perf360Event { final String text; const Perf360FormNotesChanged(this.text); @override List<Object?> get props => [text]; }
class Perf360FormSubmit extends Perf360Event { final bool draft; const Perf360FormSubmit({this.draft = false}); @override List<Object?> get props => [draft]; }
class Perf360ResultsOpened extends Perf360Event {}
class Perf360AnalyticsOpened extends Perf360Event {}


