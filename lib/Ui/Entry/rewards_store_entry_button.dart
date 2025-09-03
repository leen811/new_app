import 'package:flutter/material.dart';
import '../RewardsStore/rewards_store_page.dart';

class RewardsStoreEntryButton extends StatelessWidget {
  const RewardsStoreEntryButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.card_giftcard_outlined, size: 18),
      label: const Text('متجر المكافئات'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RewardsStorePage(),
        ),
      ),
    );
  }
}
