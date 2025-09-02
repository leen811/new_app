import 'package:flutter/material.dart';

class ActionMenuItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionMenuItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
