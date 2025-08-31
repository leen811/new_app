import 'package:flutter/material.dart';
import 'base_tile.dart';

class TileSwitch extends StatelessWidget {
  const TileSwitch({super.key, required this.title, this.subtitle, required this.value, required this.onChanged});
  final String title; final String? subtitle; final bool value; final ValueChanged<bool> onChanged;
  @override
  Widget build(BuildContext context) {
    return BaseTile(
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Align(alignment: Alignment.centerRight, child: Text(title, textAlign: TextAlign.right)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerRight, child: Text(subtitle!, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF667085), fontSize: 12))),
            ],
          ]),
        ),
        Switch(value: value, onChanged: onChanged),
      ]),
    );
  }
}


