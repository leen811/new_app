import 'package:bloc/bloc.dart';
import '../../Data/Repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final IChatRepository repository;
  ChatBloc(this.repository) : super(ChatInitial()) {
    on<ChatFetch>(_onFetch);
    on<ChatSendMock>(_onFetch);
  }

  Future<void> _onFetch(ChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    await Future<void>.delayed(const Duration(milliseconds: 600));
    try {
      final data = await repository.fetchMessages();
      if (data.isEmpty) {
        emit(ChatEmpty());
      } else {
        emit(ChatLoaded(data));
      }
    } catch (e) {
      emit(const ChatError('خطأ في تحميل الرسائل'));
    }
  }
}


