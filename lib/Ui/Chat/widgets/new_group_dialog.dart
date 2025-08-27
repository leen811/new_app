import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class NewGroupDialog extends StatefulWidget {
  const NewGroupDialog({super.key});

  @override
  State<NewGroupDialog> createState() => _NewGroupDialogState();
}

class _NewGroupDialogState extends State<NewGroupDialog> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _searchCtrl = TextEditingController();
  final List<Map<String, String>> _people = const [
    {'name': 'أحمد محمد', 'title': 'مطوّر', 'emoji': '👨‍💻'},
    {'name': 'سارة أحمد', 'title': 'مديرة', 'emoji': '👩‍💼'},
    {'name': 'فاطمة حسن', 'title': 'قائدة فريق', 'emoji': '🧕'},
    {'name': 'عمر سالم', 'title': 'مصمم', 'emoji': '🧑‍🎨'},
  ];
  final Set<int> _selected = {};

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final bool isTablet = mq.width >= 600;
    final double dialogWidth = isTablet
        ? math.min(mq.width * 0.5, 560)
        : math.min(mq.width * 0.92, 420);
    final double maxDialogHeight = math.min(mq.height * 0.82, 560);

    final filtered = _people
        .asMap()
        .entries
        .where((e) => e.value['name']!.contains(_searchCtrl.text))
        .toList();

    const Color darkBlue = Color(0xFF1E3A8A);
    final theme = Theme.of(context).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBlue, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBlue, width: 2),
        ),
      ),
    );

    final bool canCreate = _nameCtrl.text.trim().isNotEmpty && _selected.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE6E8F0)),
        ),
        child: Theme(
          data: theme,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogWidth, maxHeight: maxDialogHeight),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إنشاء مجموعة جديدة',
                        style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(hintText: 'اسم المجموعة'),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(hintText: 'وصف المجموعة (اختياري)'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'إضافة أعضاء',
                    style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      hintText: 'البحث عن موظفين…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const Divider(color: Color(0xFFE9EDF4), height: 1),
                        itemBuilder: (context, i) {
                          final originalIndex = filtered[i].key;
                          final p = filtered[i].value;
                          final checked = _selected.contains(originalIndex);
                          void toggle(bool v) {
                            setState(() {
                              if (v) {
                                _selected.add(originalIndex);
                              } else {
                                _selected.remove(originalIndex);
                              }
                            });
                          }
                          return InkWell(
                            onTap: () => toggle(!checked),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF2F4F7),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(p['emoji']!, style: const TextStyle(fontSize: 18)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['name']!,
                                          style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          p['title']!,
                                          style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF667085)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Checkbox(
                                    value: checked,
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.selected)) return darkBlue;
                                      return Colors.white;
                                    }),
                                    onChanged: (v) => toggle(v ?? false),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('إلغاء',style: TextStyle(color: darkBlue),),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: darkBlue),
                        onPressed: canCreate ? () => Navigator.of(context).pop() : null,
                        child: const Text('إنشاء المجموعة'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


