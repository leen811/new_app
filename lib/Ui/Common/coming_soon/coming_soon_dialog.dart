import 'dart:ui';
import 'package:flutter/material.dart';

class ComingSoonDialog extends StatelessWidget {
  const ComingSoonDialog({super.key, required this.featureName, this.icon});
  final String featureName;
  final IconData? icon;
  IconData _pickIcon() {
    if (featureName.contains('الإنجازات') || featureName.contains('الشارات')) return Icons.emoji_events_rounded;
    if (featureName.contains('البريد')) return Icons.mark_email_unread_rounded;
    return icon ?? Icons.auto_awesome_rounded;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            width: 560,
            height: 520,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.10), border: Border.all(color: const Color(0xFFE6EAF2).withOpacity(0.2)), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8))]),
            padding: const EdgeInsets.all(16),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(children: [
                const SizedBox(height: 8),
                Icon(_pickIcon(), size: 72, color: const Color(0xFF7C3AED)),
                const SizedBox(height: 8),
                ShaderMask(shaderCallback: (r) => const LinearGradient(colors: [Color(0xFF2F56D9), Color(0xFF7C3AED)]).createShader(r), child: const Text('قريبًا', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900))),
                const SizedBox(height: 6),
                Text('سنطلق $featureName قريبًا. تابعنا لتصلك الإشعارات.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 16),
                Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  _Dot(text: 'تتبع الإنجازات وإظهار الشارات/أوسمة التقدير'),
                  _Dot(text: 'تنبيهات بريد إلكتروني ذكية قابلة للتخصيص'),
                  _Dot(text: 'تكامل مع التوأم الرقمي لاقتراحات وتحفيز موجه'),
                ]))),
                const SizedBox(height: 12),
                const LinearProgressIndicator(minHeight: 6, color: Color(0xFF2F56D9), backgroundColor: Color(0xFFEEF2FF)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ اهتمامك مؤقتًا'))); }, child: const Text('أبلغني عند التفعيل'))),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('عودة')),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [const Icon(Icons.circle, size: 6, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(text, style: const TextStyle(color: Colors.white)))]));
}


