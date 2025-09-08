import 'package:equatable/equatable.dart';
import '../../Data/Models/meetings_models.dart';

abstract class MeetingsState extends Equatable {
  const MeetingsState();
  @override
  List<Object?> get props => [];
}

class MeetingsInitial extends MeetingsState {}
class MeetingsLoading extends MeetingsState {}

class MeetingsLoaded extends MeetingsState {
  final int currentTab; // 0 upcoming, 1 completed, 2 archived
  final MeetingsKpis kpis;
  final List<Meeting> items;
  final String query;
  const MeetingsLoaded({required this.currentTab, required this.kpis, required this.items, required this.query});
  MeetingsLoaded copyWith({int? currentTab, MeetingsKpis? kpis, List<Meeting>? items, String? query}) => MeetingsLoaded(
        currentTab: currentTab ?? this.currentTab,
        kpis: kpis ?? this.kpis,
        items: items ?? this.items,
        query: query ?? this.query,
      );
  @override
  List<Object?> get props => [currentTab, kpis, items, query];
}

class MeetingsError extends MeetingsState {
  final String message;
  const MeetingsError(this.message);
  @override
  List<Object?> get props => [message];
}


