import 'package:equatable/equatable.dart';
import '../../Data/Models/meetings_models.dart';

abstract class MyMeetingsState extends Equatable {
  const MyMeetingsState();
  @override
  List<Object?> get props => [];
}

class MyMeetingsInitial extends MyMeetingsState {}
class MyMeetingsLoading extends MyMeetingsState {}

class MyMeetingsLoaded extends MyMeetingsState {
  final int currentTab; // 0 today | 1 upcoming | 2 completed
  final MeetingsKpis kpis;
  final String query;
  final List<Meeting> items;
  final int todayCount; // aggregated across all user's upcoming meetings (not query-filtered)
  const MyMeetingsLoaded({required this.currentTab, required this.kpis, required this.query, required this.items, required this.todayCount});

  MyMeetingsLoaded copyWith({int? currentTab, MeetingsKpis? kpis, String? query, List<Meeting>? items, int? todayCount}) => MyMeetingsLoaded(
        currentTab: currentTab ?? this.currentTab,
        kpis: kpis ?? this.kpis,
        query: query ?? this.query,
        items: items ?? this.items,
        todayCount: todayCount ?? this.todayCount,
      );

  @override
  List<Object?> get props => [currentTab, kpis, query, items, todayCount];
}

class MyMeetingsError extends MyMeetingsState {
  final String message;
  const MyMeetingsError(this.message);
  @override
  List<Object?> get props => [message];
}


