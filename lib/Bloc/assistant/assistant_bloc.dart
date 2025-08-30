import 'package:bloc/bloc.dart';
import '../assistant/assistant_event.dart';
import '../assistant/assistant_state.dart';
import '../../Data/Repositories/assistant_repository.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  final IAssistantRepository repository;
  AssistantBloc(this.repository) : super(AssistantState.initial()) {
    on<AssistantOpened>(_onOpened);
    on<AssistantCleared>(_onCleared);
    on<AssistantTextChanged>((e, emit) => emit(state.copyWith(input: e.text)));
    on<AssistantSendPressed>(_onSend);
    on<AssistantQuickActionPressed>(_onQuick);
    on<AssistantSuggestionTapped>(_onSuggest);
  }

  Future<void> _onOpened(
    AssistantOpened event,
    Emitter<AssistantState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    final data = await repository.suggest();
    final welcome = AssistantMessage(
      isMe: false,
      text: data['welcome'] as String,
      at: DateTime.now(),
    );
    final actions = List<String>.from(data['actions'] as List);
    emit(
      state.copyWith(
        messages: [welcome],
        quickActions: actions,
        loading: false,
        connected: true,
      ),
    );
  }

  Future<void> _onCleared(
    AssistantCleared event,
    Emitter<AssistantState> emit,
  ) async {
    emit(AssistantState.initial());
    add(AssistantOpened());
  }

  Future<void> _onSend(
    AssistantSendPressed event,
    Emitter<AssistantState> emit,
  ) async {
    final text = state.input.trim();
    if (text.isEmpty) return;
    final mine = AssistantMessage(isMe: true, text: text, at: DateTime.now());
    final before = [...state.messages, mine];
    emit(state.copyWith(messages: before, input: '', loading: true));
    final reply = await repository.chat(text);
    final ai = AssistantMessage(
      isMe: false,
      text: reply['text'] as String,
      at: DateTime.now(),
    );
    emit(state.copyWith(messages: [...before, ai], loading: false));
  }

  Future<void> _onQuick(
    AssistantQuickActionPressed event,
    Emitter<AssistantState> emit,
  ) async {
    await repository.execute(event.action);
  }

  Future<void> _onSuggest(
    AssistantSuggestionTapped event,
    Emitter<AssistantState> emit,
  ) async {
    emit(state.copyWith(input: event.suggestion));
  }
}
