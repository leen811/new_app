import 'package:flutter/material.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.text, required this.onTextChanged, required this.onSendPressed, this.replyPreview, this.onClearReply});

  final String text;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onSendPressed;
  final Widget? replyPreview;
  final VoidCallback? onClearReply;

  @override
  Widget build(BuildContext context) {
    final hasText = text.trim().isNotEmpty;
    return Material(
      color: Colors.white,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (replyPreview != null)
            Container(
              decoration: BoxDecoration(border: const Border(top: BorderSide(color: Color(0xFFE9EDF4))), color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(children: [
                const Icon(Icons.reply, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                Expanded(child: replyPreview!),
                if (onClearReply != null)
                  IconButton(onPressed: onClearReply, icon: const Icon(Icons.close, size: 18)),
              ]),
            ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE9EDF4))),
              boxShadow: [BoxShadow(color: Color(0x0F0B1524), blurRadius: 20, offset: Offset(0, -2))],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _SendButton(enabled: hasText, onPressed: onSendPressed),
                const SizedBox(width: 12),
                IconButton(onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    autofocus: false,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      isDense: true,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    minLines: 1,
                    maxLines: 4,
                    onChanged: onTextChanged,
                    controller: TextEditingController.fromValue(TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length))),
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
              ],
            ),
          ),
          const SafeArea(child: SizedBox(height: 0)),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : 0.6,
      child: Material(
        color: const Color(0xFF90B6FF),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16),
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.send, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
