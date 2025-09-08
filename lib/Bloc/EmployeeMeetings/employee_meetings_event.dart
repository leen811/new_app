import 'package:equatable/equatable.dart';

abstract class MyMeetingsEvent extends Equatable {
  const MyMeetingsEvent();
  @override
  List<Object?> get props => [];
}

class MyMeetingsLoad extends MyMeetingsEvent {
  const MyMeetingsLoad();
}

class MyMeetingsChangeTab extends MyMeetingsEvent {
  final int index; // 0 today | 1 upcoming | 2 completed
  const MyMeetingsChangeTab(this.index);
  @override
  List<Object?> get props => [index];
}

class MyMeetingsSearchChanged extends MyMeetingsEvent {
  final String q;
  const MyMeetingsSearchChanged(this.q);
  @override
  List<Object?> get props => [q];
}

class MyMeetingsJoin extends MyMeetingsEvent {
  final String meetingId;
  const MyMeetingsJoin(this.meetingId);
  @override
  List<Object?> get props => [meetingId];
}

class MyMeetingsAddToCalendar extends MyMeetingsEvent {
  final String meetingId;
  const MyMeetingsAddToCalendar(this.meetingId);
  @override
  List<Object?> get props => [meetingId];
}


