import 'package:flutter/material.dart';
import '../Core/Widgets/glass_card.dart';
import '../Core/Theme/tokens.dart';
import '../../l10n/l10n.dart';

class HomeGuestPage extends StatelessWidget {
  const HomeGuestPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return gradientBackground(
      child: GlassCard(child: Text(s.home_guest_title, style: const TextStyle(color: Colors.white))),
    );
  }
}


