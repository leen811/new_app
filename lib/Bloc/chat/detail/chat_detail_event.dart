import 'package:equatable/equatable.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
  @override
  List<Object?> get props => [];
}

class ChatDetailOpened extends ChatDetailEvent {
  const ChatDetailOpened(this.conversationId);
  final String conversationId;
  @override
  List<Object?> get props => [conversationId];
}

class ChatHistoryLoadedMore extends ChatDetailEvent {
  const ChatHistoryLoadedMore();
}

class ChatInputChanged extends ChatDetailEvent {
  const ChatInputChanged(this.text);
  final String text;
  @override
  List<Object?> get props => [text];
}

class ChatSendPressed extends ChatDetailEvent {
  const ChatSendPressed();
}

class ChatReplyRequested extends ChatDetailEvent {
  const ChatReplyRequested(this.messageId);
  final String messageId;
  @override
  List<Object?> get props => [messageId];
}

class ChatReplyCleared extends ChatDetailEvent {
  const ChatReplyCleared();
}

class ChatMarkedRead extends ChatDetailEvent {
  const ChatMarkedRead();
}


