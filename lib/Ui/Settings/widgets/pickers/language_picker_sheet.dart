import 'package:flutter/material.dart';
import '../../../../l10n/l10n.dart';

Future<String?> showLanguagePickerSheet(BuildContext context, {required String current}) {
  final s = S.of(context);
  final options = [
    {'code': 'ar', 'label': s.settings_general_language_arabic},
    {'code': 'en', 'label': s.settings_general_language_english},
  ];
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) {
      return SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: options.length,
            itemBuilder: (context, i) {
              final opt = options[i];
              final String code = opt['code'] as String;
              final String label = opt['label'] as String;
              final bool selected = code == current;
              return InkWell(
                onTap: () => Navigator.of(context).pop(code),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE6EAF2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(children: [
                    Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
                    if (selected)
                      const Positioned(right: 8, top: 8, child: Icon(Icons.check_circle, color: Color(0xFF2F56D9))),
                  ]),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}


