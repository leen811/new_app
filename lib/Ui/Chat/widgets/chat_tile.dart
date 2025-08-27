import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Data/Models/chat_item.dart';

class ChatTile extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  const ChatTile({super.key, required this.item, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a', 'ar').format(item.lastAt).replaceAll('AM', 'ص').replaceAll('PM', 'م');
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 20, child: Text(item.avatarEmoji, style: const TextStyle(fontSize: 20))),
                if (!item.isGroup && item.online)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  )
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(item.lastText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54)),
                    if (item.pinned) const SizedBox(width: 4),
                    if (item.pinned) const Icon(Icons.star, size: 14, color: Colors.amber),
                  ],
                ),
                const SizedBox(height: 6),
                if (item.unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
                    child: Text('${item.unread}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


