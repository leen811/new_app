import 'package:flutter/material.dart';
import 'base_tile.dart';

class TileSelect extends StatelessWidget {
  const TileSelect({super.key, required this.title, required this.value, required this.options, required this.onChanged});
  final String title; final String value; final List<String> options; final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(alignment: Alignment.centerRight, child: Text(title, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
      const SizedBox(height: 6),
      BaseTile(
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            alignment: Alignment.centerRight,
            items: options
                .map((e) => DropdownMenuItem<String>(value: e, child: Align(alignment: Alignment.centerRight, child: Text(e, textAlign: TextAlign.right))))
                .toList(),
            onChanged: (v) { if (v != null) onChanged(v); },
          ),
        ),
      ),
    ]);
  }
}


