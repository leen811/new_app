import 'package:flutter/material.dart';

class ChatSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ChatSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'البحث في المحادثات...',
        prefixIcon: const Icon(Icons.search),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      onChanged: onChanged,
    );
  }
}


