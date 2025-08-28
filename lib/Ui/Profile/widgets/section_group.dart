import 'package:flutter/material.dart';
import 'section_tile.dart';

class SectionGroup extends StatelessWidget {
  const SectionGroup({super.key, required this.title, required this.tiles});
  final String title;
  final List<SectionTile> tiles;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        ),
        const Divider(height: 1, color: Color(0xFFE9EDF4)),
        ..._withDividers(tiles),
      ]),
    );
  }

  List<Widget> _withDividers(List<SectionTile> children) {
    final List<Widget> result = [];
    for (var i = 0; i < children.length; i++) {
      result.add(Padding(padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0), child: children[i]));
      if (i != children.length - 1) result.add(const Divider(height: 1, color: Color(0xFFE9EDF4)));
    }
    return result;
  }
}


