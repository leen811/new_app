import 'package:flutter/material.dart';

class GroupRewardsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int points;
  final Color color;
  final VoidCallback onGrant;
  const GroupRewardsCard({super.key, required this.title, required this.subtitle, required this.points, required this.color, required this.onGrant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: onGrant,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFF59E0B)),
              foregroundColor: const Color(0xFFF59E0B),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.groups_2_rounded),
            label: Text('$points توكينز للجميع'),
          ),
        ],
      ),
    );
  }
}


