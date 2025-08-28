import 'package:flutter/material.dart';
import '../../../Data/Models/profile_user.dart';

class GradientHeader extends StatelessWidget {
  const GradientHeader({super.key, required this.user});
  final ProfileUser user;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Color(0xFF6D28D9), Color(0xFFDB2777), Color(0xFF2563EB)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('مطوّر واجهات أمامية', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              const Text('قسم التكنولوجيا • 2.5 سنة', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Row(children: const [
                _Badge(text: '1250'),
                SizedBox(width: 8),
                _Badge(text: 'المستوى 15'),
              ]),
            ]),
          ),
          Stack(children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)], border: Border.all(color: Colors.white70)),
              alignment: Alignment.center,
              child: Text(user.avatarEmoji, style: const TextStyle(fontSize: 24)),
            ),
            if (user.online)
              Positioned(
                right: 2,
                top: 2,
                child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)])),
              ),
          ]),
        ]),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white30)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}


