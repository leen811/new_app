import 'package:flutter/material.dart';
import 'base_tile.dart';
import '../../../Common/press_fx.dart';

class TileNav extends StatelessWidget {
  const TileNav({super.key, required this.title, this.subtitle, required this.onTap});
  final String title; final String? subtitle; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: BaseTile(
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Align(alignment: Alignment.centerRight, child: Text(title, textAlign: TextAlign.right)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Align(alignment: Alignment.centerRight, child: Text(subtitle!, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF667085), fontSize: 12))),
            ],
          ])),
          const Icon(Icons.chevron_left),
        ]),
      ),
    ).withPressFX();
  }
}


