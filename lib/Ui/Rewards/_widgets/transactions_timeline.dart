import 'package:flutter/material.dart';
import '../../../Data/Models/rewards_models.dart';

class TransactionsTimeline extends StatelessWidget {
  final List<RewardTransaction> items;
  const TransactionsTimeline({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) => _TimelineCard(item: e)).toList(),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  final RewardTransaction item;
  const _TimelineCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isAdd ? const Color(0xFF16A34A) : const Color(0xFFDC2626);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E9F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.isAdd ? '+' : '-'}${item.amount} توكينز • ${item.employeeName}', style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text('بواسطة: ${item.byUser} • السبب: ${item.reason}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                          ],
                        ),
                      ),
                      Text('${item.at.year}/${item.at.month}/${item.at.day}', style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


