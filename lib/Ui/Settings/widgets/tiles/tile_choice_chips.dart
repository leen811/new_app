import 'package:flutter/material.dart';
import '../../../Common/press_fx.dart';

class TileChoiceChips extends StatelessWidget {
  const TileChoiceChips({super.key, required this.title, required this.value, required this.options, required this.onChanged, this.onExpand});
  final String title; final String value; final List<_ChoiceOpt> options; final ValueChanged<String> onChanged; final VoidCallback? onExpand;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(onPressed: onExpand, icon: const Icon(Icons.unfold_more_rounded)).withPressFX(),
        Expanded(child: Align(alignment: Alignment.centerRight, child: Text(title, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))))
      ]),
      const SizedBox(height: 6),
      Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.end, children: options.map((opt) {
        final bool selected = opt.value == value;
        return _chip(label: opt.label, icon: opt.icon, selected: selected, onTap: () => onChanged(opt.value));
      }).toList()),
    ]);
  }

  Widget _chip({required String label, required IconData icon, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2F56D9) : const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFE6EAF2)),
          boxShadow: selected ? [const BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))] : [],
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: selected ? Colors.white : const Color(0xFF475467)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: selected ? Colors.white : const Color(0xFF111827), fontWeight: FontWeight.w700, fontSize: 13)),
        ]),
      ),
    ).withPressFX();
  }
}

class _ChoiceOpt {
  const _ChoiceOpt(this.label, this.icon, this.value);
  final String label; final IconData icon; final String value;
}

List<_ChoiceOpt> choiceOptions(List<Map<String, dynamic>> maps) =>
    maps.map((m) => _ChoiceOpt(m['label'] as String, m['icon'] as IconData, (m['value'] as String?) ?? (m['label'] as String))).toList();


