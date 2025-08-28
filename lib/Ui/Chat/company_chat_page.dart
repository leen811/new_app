import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_app/Core/Animations/app_dialog.dart';
import '../../Bloc/chat/chat_list_bloc.dart';
import '../../Bloc/chat/chat_list_event.dart';
import '../../Bloc/chat/chat_list_state.dart';
import '../../Data/Repositories/chat_repository.dart';
import 'widgets/chat_tile.dart';
import 'widgets/chat_search_field.dart';
import 'widgets/new_group_dialog.dart';
import 'widgets/new_chat_dialog.dart';

class CompanyChatPage extends StatelessWidget {
  const CompanyChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('المحادثات', style: TextStyle(color: Colors.black)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => showAppDialog(
                    context: context,
                    transition: AppDialogTransition.fadeScale,
                    useBlur: false,
                    builder: (_) => const NewGroupDialog(),
                  ),
              icon: const Icon(Icons.group_add_outlined, color: Colors.black87)),
          const SizedBox(width: 4),
          IconButton(
              onPressed: () => showAppDialog(
                    context: context,
                    transition: AppDialogTransition.fadeScale,
                    useBlur: false,
                    builder: (_) => const NewChatDialog(),
                  ),
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.black87)),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (ctx) => ChatListBloc(ctx.read<IChatRepository>())..add(ChatListFetched()),
        child: const _ChatListView(),
      ),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ChatSearchField(onChanged: (q) => context.read<ChatListBloc>().add(ChatSearchQueryChanged(q))),
        ),
        Expanded(
          child: BlocBuilder<ChatListBloc, ChatListState>(
            builder: (context, state) {
              if (state is ChatListLoading) {
                return ListView.separated(
                  itemCount: 6,
                  separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                  itemBuilder: (_, __) => Container(height: 72, margin: const EdgeInsets.symmetric(horizontal: 12), color: Colors.grey.shade100),
                );
              }
              if (state is ChatListError) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(state.message),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: () => context.read<ChatListBloc>().add(ChatListFetched()), child: const Text('إعادة المحاولة')),
                  ]),
                );
              }
              if (state is ChatListEmpty) {
                return const Center(child: Text('لا توجد محادثات'));
              }
              if (state is ChatListSuccess) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n is OverscrollNotification && n.overscroll < 0 && n.metrics.extentBefore == 0) {
                      context.read<ChatListBloc>().add(ChatListRefreshed());
                    }
                    return false;
                  },
                  child: ListView.separated(
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, i) => ChatTile(
                      item: state.items[i],
                      onTap: () {
                        context.read<ChatListBloc>().add(ChatMarkedRead(state.items[i].id));
                        GoRouter.of(context).push('/chat/${state.items[i].id}');
                      },
                      onLongPress: () => context.read<ChatListBloc>().add(ChatPinnedToggled(state.items[i].id)),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}


