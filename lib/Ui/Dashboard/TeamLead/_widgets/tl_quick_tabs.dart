import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TlQuickTabs extends StatelessWidget {
  final List<String> labels;
  final int current;
  final ValueChanged<int> onChanged;
  
  const TlQuickTabs({
    super.key,
    required this.labels,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FC),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  left: current * (MediaQuery.of(context).size.width - 32 - 12) / labels.length,
                  right: (labels.length - 1 - current) * (MediaQuery.of(context).size.width - 32 - 12) / labels.length,
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: List.generate(labels.length, (index) {
                    final isActive = index == current;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => onChanged(index),
                        child: Container(
                          height: 28,
                          alignment: Alignment.center,
                          child: Text(
                            labels[index],
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                              color: isActive 
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFF9AA3B2),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
