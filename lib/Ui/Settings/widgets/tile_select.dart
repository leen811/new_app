import 'package:flutter/material.dart';

class TileSelect extends StatelessWidget {
  const TileSelect({super.key, required this.label, required this.value, required this.options, required this.onChanged});
  final String label; final String value; final List<String> options; final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(alignment: Alignment.centerRight, child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE6EAF2)),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              alignment: Alignment.centerRight,
              items: options
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Align(alignment: Alignment.centerRight, child: Text(e, textAlign: TextAlign.right)),
                      ))
                  .toList(),
              onChanged: (v) { if (v != null) onChanged(v); },
            ),
          ),
        ),
      ],
    );
  }
}


