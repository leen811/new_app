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

// --- Meetings state with scheduling overlay (inherits base fields) ---
class MeetingsWithSchedule extends MeetingsLoaded {
  final List<MeetingRoom> rooms;
  final String? selectedRoomId;
  final DateTime? start;
  final int durationMinutes;
  final RoomAvailability? availability;
  final List<SlotSuggestion> suggestions;
  final bool checking;
  final bool suggesting;

  const MeetingsWithSchedule({
    required super.currentTab,
    required super.kpis,
    required super.items,
    required super.query,
    this.rooms = const [],
    this.selectedRoomId,
    this.start,
    this.durationMinutes = 60,
    this.availability,
    this.suggestions = const [],
    this.checking = false,
    this.suggesting = false,
  });

  MeetingsWithSchedule copyWith({
    int? currentTab,
    MeetingsKpis? kpis,
    List<Meeting>? items,
    String? query,
    List<MeetingRoom>? rooms,
    String? selectedRoomId,
    DateTime? start,
    int? durationMinutes,
    RoomAvailability? availability,
    List<SlotSuggestion>? suggestions,
    bool? checking,
    bool? suggesting,
  }) => MeetingsWithSchedule(
        currentTab: currentTab ?? this.currentTab,
        kpis: kpis ?? this.kpis,
        items: items ?? this.items,
        query: query ?? this.query,
        rooms: rooms ?? this.rooms,
        selectedRoomId: selectedRoomId ?? this.selectedRoomId,
        start: start ?? this.start,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        availability: availability ?? this.availability,
        suggestions: suggestions ?? this.suggestions,
        checking: checking ?? this.checking,
        suggesting: suggesting ?? this.suggesting,
      );

  @override
  List<Object?> get props => super.props + [rooms, selectedRoomId, start, durationMinutes, availability, suggestions, checking, suggesting];
}

class MeetingsError extends MeetingsState {
  final String message;
  const MeetingsError(this.message);
  @override
  List<Object?> get props => [message];
}


