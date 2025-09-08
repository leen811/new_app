import 'package:flutter/material.dart';
import '../../../Data/Models/team_models.dart';
import 'status_dot.dart';

class MemberCard extends StatelessWidget {
  final TeamMember data;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const MemberCard({super.key, required this.data, this.onTap, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE6E9F0)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFF1F5F9),
                  backgroundImage: data.avatarUrl != null
                      ? NetworkImage(data.avatarUrl!)
                      : null,
                  child: data.avatarUrl == null
                      ? Text(
                          data.name.characters.first,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                // الوسط (اسم + مسمى + حالة + مهام + مهارات)
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.title,
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // شارة الأداء (على الجهة الأخرى)
                          Chip(
                            label: Text(
                              textAlign: TextAlign.left,
                              '${data.performancePct}%'),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'مهام ${data.tasksCount}',
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '•',
                              style: TextStyle(color: Color(0xFF9CA3AF)),
                            ),
                            const SizedBox(width: 8),
                            StatusDot(availability: data.availability),
                            const SizedBox(width: 6),
                            Text(
                              _availabilityText(data.availability),
                              style: const TextStyle(color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 6,
                          runSpacing: 6,
                          children: data.skills
                              .map(
                                (s) => Chip(
                                  label: Text(s),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // أيقونة التحرير في الجهة الأخرى فقط
                IconButton(
                  onPressed: onEdit ?? onTap,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: Color(0xFF6B7280),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _availabilityText(MemberAvailability a) {
    switch (a) {
      case MemberAvailability.available:
        return 'متاح';
      case MemberAvailability.busy:
        return 'مشغول';
      case MemberAvailability.offline:
        return 'غير متصل';
    }
  }
}
