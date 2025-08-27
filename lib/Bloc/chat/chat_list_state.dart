import 'package:equatable/equatable.dart';
import '../../Data/Models/chat_item.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();
  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}
class ChatListLoading extends ChatListState {}
class ChatListEmpty extends ChatListState {}
class ChatListError extends ChatListState {
  final String message;
  const ChatListError(this.message);
  @override
  List<Object?> get props => [message];
}
class ChatListSuccess extends ChatListState {
  final List<ChatItem> items;
  final String query;
  const ChatListSuccess({required this.items, this.query = ''});
  ChatListSuccess copyWith({List<ChatItem>? items, String? query}) =>
      ChatListSuccess(items: items ?? this.items, query: query ?? this.query);
  @override
  List<Object?> get props => [items, query];
}


