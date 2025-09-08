import 'package:equatable/equatable.dart';

enum MeetingPriority { low, medium, high }
enum MeetingType { online, onsite, hybrid }
enum MeetingStatus { upcoming, completed, archived }

class Meeting extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime date; // includes time
  final int durationMinutes;
  final MeetingPriority priority;
  final MeetingType type;
  final String? placeOrLink; // place or URL
  final List<String> participantIds;
  final List<String> departmentIds;
  final MeetingStatus status;
  final String platform; // Google Meet / Zoom / Teams ...

  const Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.durationMinutes,
    required this.priority,
    required this.type,
    this.placeOrLink,
    required this.participantIds,
    required this.departmentIds,
    required this.status,
    required this.platform,
  });

  Meeting copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    int? durationMinutes,
    MeetingPriority? priority,
    MeetingType? type,
    String? placeOrLink,
    List<String>? participantIds,
    List<String>? departmentIds,
    MeetingStatus? status,
    String? platform,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      placeOrLink: placeOrLink ?? this.placeOrLink,
      participantIds: participantIds ?? this.participantIds,
      departmentIds: departmentIds ?? this.departmentIds,
      status: status ?? this.status,
      platform: platform ?? this.platform,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        date,
        durationMinutes,
        priority,
        type,
        placeOrLink,
        participantIds,
        departmentIds,
        status,
        platform,
      ];
}

class MeetingsKpis extends Equatable {
  final int scheduled;
  final int completed;
  final int totalMinutes;
  final int participants;

  const MeetingsKpis({
    required this.scheduled,
    required this.completed,
    required this.totalMinutes,
    required this.participants,
  });

  MeetingsKpis copyWith({int? scheduled, int? completed, int? totalMinutes, int? participants}) => MeetingsKpis(
        scheduled: scheduled ?? this.scheduled,
        completed: completed ?? this.completed,
        totalMinutes: totalMinutes ?? this.totalMinutes,
        participants: participants ?? this.participants,
      );

  @override
  List<Object?> get props => [scheduled, completed, totalMinutes, participants];
}


// --- Rooms & Availability Models ---

class MeetingRoom extends Equatable {
  final String id;
  final String name;
  final int? capacity;
  final String? location;
  const MeetingRoom({required this.id, required this.name, this.capacity, this.location});
  @override
  List<Object?> get props => [id, name, capacity, location];
}

class RoomAvailability extends Equatable {
  final String roomId;
  final DateTime start;
  final DateTime end;
  final bool isFree;
  final List<(DateTime from, DateTime to)> conflicts;
  const RoomAvailability({required this.roomId, required this.start, required this.end, required this.isFree, required this.conflicts});
  @override
  List<Object?> get props => [roomId, start, end, isFree, conflicts];
}

class SlotSuggestion extends Equatable {
  final DateTime start;
  final DateTime end;
  const SlotSuggestion(this.start, this.end);
  @override
  List<Object?> get props => [start, end];
}

