import 'package:equatable/equatable.dart';
import '../../Data/Models/meetings_models.dart';

abstract class MeetingsEvent extends Equatable {
  const MeetingsEvent();
  @override
  List<Object?> get props => [];
}

class MeetingsLoad extends MeetingsEvent {
  const MeetingsLoad();
}

class MeetingsChangeTab extends MeetingsEvent {
  final int index; // 0 upcoming, 1 completed, 2 archived
  const MeetingsChangeTab(this.index);
  @override
  List<Object?> get props => [index];
}

class MeetingsSearchChanged extends MeetingsEvent {
  final String query;
  const MeetingsSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class MeetingCreateSubmitted extends MeetingsEvent {
  final Meeting draft;
  const MeetingCreateSubmitted(this.draft);
  @override
  List<Object?> get props => [draft];
}

class MeetingUpdateSubmitted extends MeetingsEvent {
  final String id;
  final Meeting patch;
  const MeetingUpdateSubmitted(this.id, this.patch);
  @override
  List<Object?> get props => [id, patch];
}

class MeetingDelete extends MeetingsEvent {
  final String id;
  const MeetingDelete(this.id);
  @override
  List<Object?> get props => [id];
}

// --- Scheduling Sheet Events ---
class ScheduleInit extends MeetingsEvent {
  const ScheduleInit();
}

class ScheduleRoomChanged extends MeetingsEvent {
  final String roomId;
  const ScheduleRoomChanged(this.roomId);
  @override
  List<Object?> get props => [roomId];
}

class ScheduleDateTimeChanged extends MeetingsEvent {
  final DateTime start;
  final int durationMinutes;
  const ScheduleDateTimeChanged(this.start, this.durationMinutes);
  @override
  List<Object?> get props => [start, durationMinutes];
}

class ScheduleCheckAvailability extends MeetingsEvent {
  const ScheduleCheckAvailability();
}

class ScheduleRequestSuggestions extends MeetingsEvent {
  const ScheduleRequestSuggestions();
}


