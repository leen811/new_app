import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Core/Theme/app_gradients.dart';
import '../Common/glass.dart';
import '../../Bloc/assistant/assistant_bloc.dart';
import '../../Bloc/assistant/assistant_event.dart';
import '../../Bloc/assistant/assistant_state.dart';
import '../../Data/Repositories/assistant_repository.dart';

class AssistantPage extends StatelessWidget {
  const AssistantPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) =>
          AssistantBloc(ctx.read<IAssistantRepository>())
            ..add(AssistantOpened()),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();
  @override
  Widget build(BuildContext context) {
    final inputCtrl = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppGradients.splash),
          ),
          const Positioned.fill(child: GlassBackdrop(opacity: 0.10, sigma: 20)),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'المساعد الذكي',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'مسح',
                            onPressed: () => context.read<AssistantBloc>().add(
                              AssistantCleared(),
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(Icons.circle, size: 8, color: Colors.green),
                          SizedBox(width: 6),
                          Text(
                            'المساعد الذكي متصل',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.white24, height: 1),
                    ],
                  ),
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: BlocBuilder<AssistantBloc, AssistantState>(
                      builder: (context, state) {
                        final items = <Widget>[];
                        for (var i = 0; i < state.messages.length; i++) {
                          final m = state.messages[i];
                          final bubble = Align(
                            alignment: m.isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              constraints: const BoxConstraints(maxWidth: 600),
                              child: m.isMe
                                  ? Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.75),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFE6EAF2),
                                        ),
                                      ),
                                      child: Text(m.text),
                                    )
                                  : GlassBackdrop(
                                      radius: BorderRadius.circular(12),
                                      opacity: 0.18,
                                      sigma: 16,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          m.text,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          );
                          items.add(bubble);
                          items.add(
                            Padding(
                              padding: const EdgeInsetsDirectional.only(
                                end: 8,
                                start: 8,
                              ),
                              child: Text(
                                _fmt(m.at),
                                style: const TextStyle(
                                  color: Color(0xFF98A2B3),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          );
                          if (i == 0 && state.quickActions.isNotEmpty) {
                            items.add(
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: state.quickActions
                                    .map(
                                      (e) => ActionChip(
                                        label: Text(e),
                                        onPressed: () =>
                                            context.read<AssistantBloc>().add(
                                              AssistantQuickActionPressed(e),
                                            ),
                                        backgroundColor: Colors.white
                                            .withOpacity(0.75),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          }
                        }
                        return ListView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          children: items,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: GlassBackdrop(
                    radius: BorderRadius.circular(12),
                    opacity: 0.10,
                    sigma: 14,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => context.read<AssistantBloc>().add(
                              AssistantSendPressed(),
                            ),
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFF2F56D9),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: inputCtrl,
                              autofocus: false,
                              onChanged: (v) => context
                                  .read<AssistantBloc>()
                                  .add(AssistantTextChanged(v)),
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              decoration: const InputDecoration.collapsed(
                                hintText: 'اكتب رسالتك هنا...',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const SafeArea(top: false, child: SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
