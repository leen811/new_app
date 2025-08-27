import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();
  @override
  List<Object?> get props => [];
}

class ChatListFetched extends ChatListEvent {}
class ChatListRefreshed extends ChatListEvent {}
class ChatSearchQueryChanged extends ChatListEvent {
  final String query;
  const ChatSearchQueryChanged(this.query);
  @override
  List<Object?> get props => [query];
}
class ChatPinnedToggled extends ChatListEvent {
  final String id;
  const ChatPinnedToggled(this.id);
  @override
  List<Object?> get props => [id];
}
class ChatMarkedRead extends ChatListEvent {
  final String id;
  const ChatMarkedRead(this.id);
  @override
  List<Object?> get props => [id];
}


