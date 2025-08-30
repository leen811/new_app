import 'package:flutter/material.dart';

class PreviewPanel extends StatelessWidget {
  const PreviewPanel({super.key, required this.score});
  final double score;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE6EAF2))),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(children: const [Icon(Icons.remove_red_eye_outlined, size: 18), SizedBox(width: 6), Text('معاينة التقييم', style: TextStyle(fontWeight: FontWeight.w800))]),
        const SizedBox(height: 12),
        if (score <= 0)
          Column(children: const [
            Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFFD6DBE3)),
            SizedBox(height: 8),
            Text('املأ التقييم لمعاينة النتيجة', style: TextStyle(color: Color(0xFF667085))),
          ])
        else
          Column(children: [
            Text('${score.toStringAsFixed(1)}/5', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: score / 5, minHeight: 6, color: const Color(0xFF2F56D9), backgroundColor: const Color(0xFFE6EAF2)),
          ]),
      ]),
    );
  }
}


