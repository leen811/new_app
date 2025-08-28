import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.isMe,
    required this.text,
    required this.createdAt,
    this.replyToId,
    this.localPending = false,
  });

  final String id;
  final String authorId;
  final String authorName;
  final bool isMe;
  final String text;
  final DateTime createdAt;
  final String? replyToId;
  final bool localPending;

  Message copyWith({
    String? id,
    bool? localPending,
  }) => Message(
        id: id ?? this.id,
        authorId: authorId,
        authorName: authorName,
        isMe: isMe,
        text: text,
        createdAt: createdAt,
        replyToId: replyToId,
        localPending: localPending ?? this.localPending,
      );

  @override
  List<Object?> get props => [id, authorId, authorName, isMe, text, createdAt, replyToId, localPending];
}

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();
  @override
  List<Object?> get props => [];
}

class ChatDetailInitial extends ChatDetailState {}

class ChatDetailLoading extends ChatDetailState {}

class ChatDetailError extends ChatDetailState {
  const ChatDetailError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ChatDetailSuccess extends ChatDetailState {
  const ChatDetailSuccess({
    required this.messages,
    required this.canLoadMore,
    required this.input,
    required this.replyingTo,
    required this.sending,
  });

  final List<Message> messages; // ascending
  final bool canLoadMore;
  final String input;
  final Message? replyingTo;
  final bool sending;

  ChatDetailSuccess copyWith({
    List<Message>? messages,
    bool? canLoadMore,
    String? input,
    Message? replyingTo,
    bool replyingToNull = false,
    bool? sending,
  }) => ChatDetailSuccess(
        messages: messages ?? this.messages,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        input: input ?? this.input,
        replyingTo: replyingToNull ? null : (replyingTo ?? this.replyingTo),
        sending: sending ?? this.sending,
      );

  @override
  List<Object?> get props => [messages, canLoadMore, input, replyingTo, sending];
}


