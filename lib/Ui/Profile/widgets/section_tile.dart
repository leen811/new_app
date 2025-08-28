import 'package:flutter/material.dart';

class SectionTile extends StatelessWidget {
  const SectionTile({super.key, required this.title, required this.subtitle, required this.trailingIcon, this.onTap});
  final String title;
  final String subtitle;
  final IconData trailingIcon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Row(children: [
          const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: Color(0xFF667085), fontSize: 12)),
          ])),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(999)),
            child: Icon(trailingIcon, size: 16, color: const Color(0xFF667085)),
          ),
        ]),
      ),
    );
  }
}


