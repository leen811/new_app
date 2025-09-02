import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../Data/Models/employee_home_models.dart';

class AchievementItem extends StatelessWidget {
  final Achievement achievement;

  const AchievementItem({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(achievement.iconName),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getIconData(achievement.iconName),
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  achievement.description,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'star':
        return Icons.star;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'handshake':
        return Icons.handshake;
      case 'school':
        return Icons.school;
      default:
        return Icons.star;
    }
  }
  
  Color _getIconBackgroundColor(String iconName) {
    switch (iconName) {
      case 'star':
        return const Color(0xFFFFD700);
      case 'emoji_events':
        return const Color(0xFFFFD700);
      case 'handshake':
        return const Color(0xFFF4E4C1);
      case 'school':
        return const Color(0xFFFBBF24);
      default:
        return const Color(0xFFF1F5F9);
    }
  }
}
