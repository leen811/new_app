import 'package:equatable/equatable.dart';

abstract class AssistantEvent extends Equatable {
  const AssistantEvent();
  @override
  List<Object?> get props => [];
}

class AssistantOpened extends AssistantEvent {}

class AssistantCleared extends AssistantEvent {}

class AssistantTextChanged extends AssistantEvent {
  final String text;
  const AssistantTextChanged(this.text);
  @override
  List<Object?> get props => [text];
}

class AssistantSendPressed extends AssistantEvent {}

class AssistantQuickActionPressed extends AssistantEvent {
  final String action;
  const AssistantQuickActionPressed(this.action);
  @override
  List<Object?> get props => [action];
}

class AssistantSuggestionTapped extends AssistantEvent {
  final String suggestion;
  const AssistantSuggestionTapped(this.suggestion);
  @override
  List<Object?> get props => [suggestion];
}
