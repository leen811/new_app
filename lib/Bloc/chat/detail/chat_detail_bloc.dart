import 'package:bloc/bloc.dart';

import '../../../Data/Repositories/chat_detail_repository.dart';
import 'chat_detail_event.dart';
import 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  ChatDetailBloc(this.repository) : super(ChatDetailInitial()) {
    on<ChatDetailOpened>(_onOpened);
    on<ChatHistoryLoadedMore>(_onLoadMore);
    on<ChatInputChanged>(_onInputChanged);
    on<ChatSendPressed>(_onSend);
    on<ChatReplyRequested>(_onReplyRequested);
    on<ChatReplyCleared>(_onReplyCleared);
    on<ChatMarkedRead>(_onMarkedRead);
  }

  final IChatDetailRepository repository;
  String? _conversationId;
  DateTime? _oldestLoadedBefore;

  Future<void> _onOpened(ChatDetailOpened event, Emitter<ChatDetailState> emit) async {
    _conversationId = event.conversationId;
    emit(ChatDetailLoading());
    try {
      final history = await repository.fetchHistory(conversationId: event.conversationId, before: null);
      await repository.markRead(event.conversationId);
      _oldestLoadedBefore = history.oldestTs;
      emit(ChatDetailSuccess(
        messages: history.messages,
        canLoadMore: history.canLoadMore,
        input: '',
        replyingTo: null,
        sending: false,
      ));
    } catch (e) {
      emit(ChatDetailError(e.toString()));
    }
  }

  Future<void> _onLoadMore(ChatHistoryLoadedMore event, Emitter<ChatDetailState> emit) async {
    final current = state;
    if (current is! ChatDetailSuccess || !current.canLoadMore || _conversationId == null) return;
    try {
      final h = await repository.fetchHistory(conversationId: _conversationId!, before: _oldestLoadedBefore);
      _oldestLoadedBefore = h.oldestTs ?? _oldestLoadedBefore;
      emit(current.copyWith(messages: [...h.messages, ...current.messages], canLoadMore: h.canLoadMore));
    } catch (_) {}
  }

  void _onInputChanged(ChatInputChanged event, Emitter<ChatDetailState> emit) {
    final current = state;
    if (current is ChatDetailSuccess) {
      emit(current.copyWith(input: event.text));
    }
  }

  Future<void> _onSend(ChatSendPressed event, Emitter<ChatDetailState> emit) async {
    final current = state;
    if (current is! ChatDetailSuccess || _conversationId == null) return;
    final trimmed = current.input.trim();
    if (trimmed.isEmpty) return;
    final pending = Message(
      id: 'local-${DateTime.now().microsecondsSinceEpoch}',
      authorId: 'me',
      authorName: 'أنا',
      isMe: true,
      text: trimmed,
      createdAt: DateTime.now(),
      replyToId: current.replyingTo?.id,
      localPending: true,
    );
    emit(current.copyWith(
      messages: [...current.messages, pending],
      input: '',
      replyingToNull: true,
      sending: true,
    ));
    try {
      final sent = await repository.sendMessage(
        conversationId: _conversationId!,
        text: trimmed,
        replyToId: pending.replyToId,
      );
      final updated = List<Message>.from((state as ChatDetailSuccess).messages);
      final idx = updated.indexWhere((m) => m.id == pending.id);
      if (idx != -1) {
        updated[idx] = pending.copyWith(id: sent.id, localPending: false);
      } else {
        updated.add(pending.copyWith(id: sent.id, localPending: false));
      }
      emit((state as ChatDetailSuccess).copyWith(messages: updated, sending: false));
    } catch (e) {
      emit((state as ChatDetailSuccess).copyWith(sending: false));
    }
  }

  void _onReplyRequested(ChatReplyRequested event, Emitter<ChatDetailState> emit) {
    final current = state;
    if (current is ChatDetailSuccess) {
      final msg = current.messages.firstWhere((m) => m.id == event.messageId, orElse: () => current.messages.last);
      emit(current.copyWith(replyingTo: msg));
    }
  }

  void _onReplyCleared(ChatReplyCleared event, Emitter<ChatDetailState> emit) {
    final current = state;
    if (current is ChatDetailSuccess) {
      emit(current.copyWith(replyingToNull: true));
    }
  }

  Future<void> _onMarkedRead(ChatMarkedRead event, Emitter<ChatDetailState> emit) async {
    if (_conversationId == null) return;
    try {
      await repository.markRead(_conversationId!);
    } catch (_) {}
  }
}


