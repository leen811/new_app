import 'package:bloc/bloc.dart';
import '../../Data/Repositories/chat_repository.dart';
import '../../Data/Models/chat_item.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final IChatRepository repository;
  List<ChatItem> _all = const [];

  ChatListBloc(this.repository) : super(ChatListInitial()) {
    on<ChatListFetched>(_onFetch);
    on<ChatListRefreshed>(_onFetch);
    on<ChatSearchQueryChanged>(_onQuery);
    on<ChatPinnedToggled>(_onPin);
    on<ChatMarkedRead>(_onMarkRead);
  }

  Future<void> _onFetch(ChatListEvent event, Emitter<ChatListState> emit) async {
    emit(ChatListLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      _all = await repository.fetchConversations();
      _sort();
      if (_all.isEmpty) {
        emit(ChatListEmpty());
      } else {
        emit(ChatListSuccess(items: _all));
      }
    } catch (e) {
      emit(const ChatListError('تعذر تحميل المحادثات'));
    }
  }

  void _onQuery(ChatSearchQueryChanged event, Emitter<ChatListState> emit) {
    final q = event.query.trim();
    if (state is! ChatListSuccess) {
      emit(ChatListSuccess(items: _filter(_all, q), query: q));
    } else {
      emit((state as ChatListSuccess).copyWith(items: _filter(_all, q), query: q));
    }
  }

  Future<void> _onPin(ChatPinnedToggled event, Emitter<ChatListState> emit) async {
    final idx = _all.indexWhere((e) => e.id == event.id);
    if (idx == -1) return;
    _all[idx] = _all[idx].copyWith(pinned: !_all[idx].pinned);
    _sort();
    repository.togglePinned(event.id);
    _refreshView(emit);
  }

  Future<void> _onMarkRead(ChatMarkedRead event, Emitter<ChatListState> emit) async {
    final idx = _all.indexWhere((e) => e.id == event.id);
    if (idx == -1) return;
    _all[idx] = _all[idx].copyWith(unread: 0);
    repository.markRead(event.id);
    _refreshView(emit);
  }

  void _sort() {
    _all.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return b.lastAt.compareTo(a.lastAt);
    });
  }

  List<ChatItem> _filter(List<ChatItem> list, String q) {
    if (q.isEmpty) return List.of(list);
    final qc = _normalize(q);
    return list.where((e) {
      final n = _normalize(e.name);
      final t = _normalize(e.lastText);
      return n.contains(qc) || t.contains(qc);
    }).toList();
  }

  String _normalize(String s) => s
      .replaceAll(RegExp(r'[\u064B-\u0652]'), '') // remove Arabic diacritics
      .toLowerCase();

  void _refreshView(Emitter<ChatListState> emit) {
    final currentQuery = state is ChatListSuccess ? (state as ChatListSuccess).query : '';
    emit(ChatListSuccess(items: _filter(_all, currentQuery), query: currentQuery));
  }
}


