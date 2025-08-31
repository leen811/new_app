import 'dart:ui';
import 'package:flutter/material.dart';
import '../press_fx.dart';

class ComingSoonSheet extends StatefulWidget {
  const ComingSoonSheet({super.key, required this.featureName, this.icon});
  final String featureName;
  final IconData? icon;
  @override
  State<ComingSoonSheet> createState() => _ComingSoonSheetState();
}

class _ComingSoonSheetState extends State<ComingSoonSheet> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 220))..forward();
  @override
  void dispose() { _ac.dispose(); super.dispose(); }
  IconData _pickIcon() {
    final n = widget.featureName;
    if (n.contains('الإنجازات') || n.contains('الشارات')) return Icons.emoji_events_rounded;
    if (n.contains('البريد')) return Icons.mark_email_unread_rounded;
    return widget.icon ?? Icons.auto_awesome_rounded;
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: size.height * 0.75,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.10), border: Border(top: BorderSide(color: const Color(0xFFE6EAF2).withOpacity(0.2))), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))]),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(999))),
                const SizedBox(height: 16),
                ScaleTransition(scale: CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic), child: Icon(_pickIcon(), size: 56, color: const Color(0xFF7C3AED))),
                const SizedBox(height: 8),
                ShaderMask(shaderCallback: (r) => const LinearGradient(colors: [Color(0xFF2F56D9), Color(0xFF7C3AED)]).createShader(r), child: const Text('قريبًا', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))),
                const SizedBox(height: 6),
                Text('سنطلق ${widget.featureName} قريبًا. تابعنا لتصلك الإشعارات.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 13)),
                const SizedBox(height: 16),
                Expanded(child: _Bullets(featureName: widget.featureName)),
                const SizedBox(height: 12),
                const LinearProgressIndicator(minHeight: 6, color: Color(0xFF2F56D9), backgroundColor: Color(0xFFEEF2FF)),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: ElevatedButton(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ اهتمامك مؤقتًا'))); }, child: const Text('أبلغني عند التفعيل')).withPressFX()),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('عودة')).withPressFX(),
                ])
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.featureName});
  final String featureName;
  @override
  Widget build(BuildContext context) {
    final isAch = featureName.contains('الإنجازات');
    final points = [
      if (isAch) 'تتبع الإنجازات وإظهار الشارات/أوسمة التقدير' else 'تنبيهات بريد إلكتروني ذكية قابلة للتخصيص',
      'تكامل مع التوأم الرقمي لاقتراحات وتحفيز موجه',
      'تجربة استخدام محسّنة وواجهة حديثة',
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: points.map((t) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [const Icon(Icons.circle, size: 6, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(t, style: const TextStyle(color: Colors.white)))]))).toList());
  }
}


