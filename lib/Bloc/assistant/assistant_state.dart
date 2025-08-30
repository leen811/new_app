import 'package:equatable/equatable.dart';

class AssistantMessage extends Equatable {
  final bool isMe;
  final String text;
  final DateTime at;
  const AssistantMessage({
    required this.isMe,
    required this.text,
    required this.at,
  });
  @override
  List<Object?> get props => [isMe, text, at];
}

class AssistantState extends Equatable {
  final List<AssistantMessage> messages;
  final List<String> quickActions;
  final String input;
  final bool loading;
  final bool connected;
  const AssistantState({
    required this.messages,
    required this.quickActions,
    required this.input,
    required this.loading,
    required this.connected,
  });

  factory AssistantState.initial() => const AssistantState(
    messages: [],
    quickActions: [],
    input: '',
    loading: false,
    connected: true,
  );

  AssistantState copyWith({
    List<AssistantMessage>? messages,
    List<String>? quickActions,
    String? input,
    bool? loading,
    bool? connected,
  }) => AssistantState(
    messages: messages ?? this.messages,
    quickActions: quickActions ?? this.quickActions,
    input: input ?? this.input,
    loading: loading ?? this.loading,
    connected: connected ?? this.connected,
  );

  @override
  List<Object?> get props => [
    messages,
    quickActions,
    input,
    loading,
    connected,
  ];
}
