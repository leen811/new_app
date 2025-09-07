import 'package:flutter/material.dart';
import '../../../../Data/Models/store_models.dart';

class ProductAdminCard extends StatelessWidget {
  final StoreProduct item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;
  const ProductAdminCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // صورة 16:9
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(item.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Color(0xFFF59E0B),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${item.tokenPrice} توكينز',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    Switch(
                      value: item.active,
                      onChanged: onToggle,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: const Color.fromARGB(255, 255, 255, 255),
                      activeTrackColor: const Color.fromARGB(255, 224, 143, 35),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                     Expanded(
                       child: OutlinedButton.icon(
                         style: OutlinedButton.styleFrom(
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                           foregroundColor: const Color(0xFFF59E0B),
                           side: const BorderSide(color: Color(0xFFF59E0B)),
                         ),
                         onPressed: onEdit,
                         icon: const Icon(Icons.edit),
                         label: const Text('تعديل'),
                       ),
                     ),
                     const SizedBox(width: 8),
                     Expanded(
                       child: OutlinedButton.icon(
                         style: OutlinedButton.styleFrom(
                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                           foregroundColor: const Color(0xFFDC2626),
                           side: const BorderSide(color: Color(0xFFDC2626)),
                         ),
                         onPressed: onDelete,
                         icon: const Icon(Icons.delete_outline),
                         label: const Text('حذف'),
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
