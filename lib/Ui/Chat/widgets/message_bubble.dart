import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.isMe, required this.text, required this.createdAt, this.isReplyIndicatorVisible = true});

  final bool isMe;
  final String text;
  final DateTime createdAt;
  final bool isReplyIndicatorVisible;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('h:mm a', 'ar').format(createdAt);
    final bubbleColor = isMe ? const Color(0xFF90B6FF) : Colors.white;
    final border = isMe ? null : Border.all(color: const Color(0xFFE6EAF2));

    final content = Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 14.5, color: Colors.black87, height: 1.35),
          textAlign: isMe ? TextAlign.right : TextAlign.left,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isReplyIndicatorVisible)
              Icon(
                Icons.reply,
                size: 14,
                color: Colors.grey.shade500,
              ),
            const SizedBox(width: 6),
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
            ),
          ],
        ),
      ],
    );

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: bubbleColor,
          border: border,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F0B1524),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: content,
      ),
    );
  }
}
