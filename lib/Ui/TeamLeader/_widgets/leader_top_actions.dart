import 'package:flutter/material.dart';

class LeaderTopActions extends StatelessWidget {
  final VoidCallback onAdd;
  const LeaderTopActions({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('إدارة الفريق'),
      centerTitle: true,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: const BackButton(),
      actions: [
        IconButton(
          tooltip: 'إضافة عضو',
          onPressed: onAdd,
          icon: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Color(0xFF16A34A),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}


