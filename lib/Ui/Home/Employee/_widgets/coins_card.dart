import 'package:flutter/material.dart';
import 'kpi_small_card.dart';

class CoinsCard extends StatelessWidget {
  final int value;

  const CoinsCard({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return KpiSmallCard(
      icon: Icons.card_giftcard,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFFF7E6),
      title: 'بصمة كوينز',
      value: Text('$value'),
    );
  }
}
