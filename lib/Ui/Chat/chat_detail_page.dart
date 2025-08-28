import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../Bloc/chat/detail/chat_detail_bloc.dart';
import '../../Bloc/chat/detail/chat_detail_event.dart';
import '../../Bloc/chat/detail/chat_detail_state.dart';
import '../../Data/Repositories/chat_detail_repository.dart';
import 'widgets/message_bubble.dart';
import 'widgets/chat_input_bar.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.conversationId});
  final String conversationId;
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure Arabic locale for times
    Intl.defaultLocale = 'ar';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => ChatDetailBloc(ctx.read<IChatDetailRepository>())
        ..add(ChatDetailOpened(widget.conversationId))
        ..add(const ChatMarkedRead()),
      child: BlocConsumer<ChatDetailBloc, ChatDetailState>(
        listenWhen: (p, c) => c is ChatDetailSuccess && p is ChatDetailSuccess && c.messages.length != p.messages.length,
        listener: (context, state) {
          if (state is ChatDetailSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_controller.hasClients) {
                _controller.animateTo(
                  _controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_ios_new)),
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('أحمد محمد', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black)),
                  SizedBox(height: 2),
                  Text('متصل الآن', style: TextStyle(fontSize: 12, color: Colors.green)),
                ],
              ),
              actions: const [Padding(padding: EdgeInsetsDirectional.only(end: 8), child: Icon(Icons.more_vert))],
              bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Divider(height: 1, color: const Color(0xFFE9EDF4)) ),
            ),
            body: _Body(controller: _controller),
          );
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatDetailBloc, ChatDetailState>(
            builder: (context, state) {
              if (state is ChatDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ChatDetailError) {
                return Center(child: Text(state.message));
              }
              if (state is! ChatDetailSuccess) {
                return const SizedBox.shrink();
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n.metrics.pixels <= 40 && state.canLoadMore) {
                    context.read<ChatDetailBloc>().add(const ChatHistoryLoadedMore());
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.messages.length + (state.canLoadMore ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (state.canLoadMore && i == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
                      );
                    }
                    final idx = state.canLoadMore ? i - 1 : i;
                    final m = state.messages[idx];
                    return GestureDetector(
                      onLongPress: () => _showMessageSheet(context, m),
                      child: MessageBubble(isMe: m.isMe, text: m.text, createdAt: m.createdAt),
                    );
                  },
                ),
              );
            },
          ),
        ),
        _InputArea(),
      ],
    );
  }
}

class _InputArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatDetailBloc, ChatDetailState>(
      builder: (context, state) {
        if (state is! ChatDetailSuccess) return const SizedBox.shrink();
        return ChatInputBar(
          text: state.input,
          onTextChanged: (t) => context.read<ChatDetailBloc>().add(ChatInputChanged(t)),
          onSendPressed: () => context.read<ChatDetailBloc>().add(const ChatSendPressed()),
          replyPreview: state.replyingTo == null
              ? null
              : Row(children: [
                  const CircleAvatar(radius: 10, backgroundColor: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(state.replyingTo!.text, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
          onClearReply: state.replyingTo == null ? null : () => context.read<ChatDetailBloc>().add(const ChatReplyCleared()),
        );
      },
    );
  }
}

void _showMessageSheet(BuildContext context, Message m) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.reply), title: const Text('رد'), onTap: () {
              Navigator.pop(context);
              context.read<ChatDetailBloc>().add(ChatReplyRequested(m.id));
            }),
            const ListTile(leading: Icon(Icons.copy), title: Text('نسخ')),
            const ListTile(leading: Icon(Icons.delete_outline), title: Text('حذف')),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}


