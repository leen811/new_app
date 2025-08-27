import 'package:flutter/material.dart';

Future<void> showSmoothDialog(BuildContext context, Widget child) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dialog',
    barrierColor: Colors.black.withOpacity(0.35),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, animation, secondary, _) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: fade,
        child: Transform.translate(
          offset: Offset(0, (1 - curved.value) * 24),
          child: Transform.scale(
            scale: 0.92 + 0.08 * curved.value,
            child: Center(child: child),
          ),
        ),
      );
    },
  );
}


