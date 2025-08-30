import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({super.key, required this.label, required this.controller, this.hint, this.readOnly=false, this.keyboardType, this.onChanged, this.maxLines=1, this.error});
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool readOnly;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final int maxLines;
  final String? error;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Align(alignment: Alignment.centerRight, child: Text(label, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
      const SizedBox(height: 6),
      TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE6EAF2))),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF2F56D9))),
          contentPadding: EdgeInsetsDirectional.fromSTEB(12, 12, 16, 12),
        ).copyWith(hintText: hint, errorText: error),
        onChanged: onChanged,
      ),
    ]);
  }
}


