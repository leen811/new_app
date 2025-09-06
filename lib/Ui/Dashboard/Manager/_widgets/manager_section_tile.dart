import 'package:flutter/material.dart';
import '../../../../Data/Models/manager_dashboard_models.dart';
import '../../../Common/press_fx.dart';

/// بلاطة قسم في لوحة الإدارة
class ManagerSectionTile extends StatelessWidget {
  final SectionLink link;
  
  const ManagerSectionTile({
    super.key,
    required this.link,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE6E9F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: link.onTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('قريبًا'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
            children: [
              // سهم التنقل
              const Icon(
                Icons.chevron_left,
                color: Color(0xFF6B7280),
                size: 20,
              ),
              
              const SizedBox(width: 12),
              
              // المحتوى النصي
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // العنوان
                    Text(
                      link.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.right,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // الوصف
                    Text(
                      link.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        height: 1.3,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // الأيقونة في كبسولة ملونة
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: link.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  link.icon,
                  color: link.color,
                  size: 24,
                ),
              ),
            ],
          ),
        ).withPressFX(),
      ),
    );
  }
}
