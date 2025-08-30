import 'package:flutter/material.dart';

class InsightSection extends StatelessWidget {
  const InsightSection({super.key, required this.title, required this.bullets, required this.startColor, required this.endColor});
  final String title;
  final List<String> bullets;
  final Color startColor;
  final Color endColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      child: Stack(children: [
        Positioned.fill(
          left: 0,
          right: null,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [startColor, endColor.withOpacity(0.6)]),
              ),
            ),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: startColor)),
          const SizedBox(height: 8),
          ...bullets.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: startColor, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(t)),
                ]),
              )),
        ]),
      ]),
    );
  }
}


