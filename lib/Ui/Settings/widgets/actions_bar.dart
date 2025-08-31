import 'package:flutter/material.dart';

class ActionsBar extends StatelessWidget {
  const ActionsBar({super.key, required this.editing, required this.onEditToggle});
  final bool editing; final VoidCallback onEditToggle;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onEditToggle,
        child: Text(editing ? 'إلغاء' : 'تعديل'),
      ),
    );
  }
}


