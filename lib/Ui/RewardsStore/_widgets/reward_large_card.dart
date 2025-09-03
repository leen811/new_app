import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Data/Models/rewards_models.dart';

class RewardLargeCard extends StatelessWidget {
  final RewardItem item;
  
  const RewardLargeCard({
    super.key,
    required this.item,
  });
  
  // لون موحد للكاردات
  Color _getCardColor(int index) {
    return const Color(0xFFF59E0B); // برتقالي موحد
  }
  
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('ar');
    final cardColor = _getCardColor(item.hashCode);
    
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1524).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط ملون في الأعلى
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            // صورة العنصر
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // أيقونة صغيرة يسار الصورة
                if (item.leadingIcon != null)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.leadingIcon,
                        size: 16,
                        color: cardColor,
                      ),
                    ),
                  ),
                // شارة "مميز" أعلى اليمين
                if (item.featured)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'مميز',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: cardColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // محتوى البطاقة
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667085),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // السعر (على اليسار)
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on_outlined,
                            size: 16,
                            color: cardColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            formatter.format(item.priceCoins),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: cardColor,
                            ),
                          ),
                        ],
                      ),
                      // زر الاستبدال (على اليمين)
                      Container(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: إضافة منطق الاستبدال
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: cardColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            'استبدال',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cardColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        );
    }
  }

