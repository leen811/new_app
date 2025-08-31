import 'package:flutter/material.dart';
import '../../Common/press_fx.dart';

class StarBar extends StatefulWidget {
  const StarBar({super.key, required this.value, required this.onChanged, this.size = 22, this.gap = 4, this.activeColor = const Color(0xFFF59E0B), this.inactiveColor = const Color(0xFFD6DBE3), this.readOnly = false});
  final double value; // 0..5
  final ValueChanged<double> onChanged;
  final double size;
  final double gap;
  final Color activeColor;
  final Color inactiveColor;
  final bool readOnly;

  @override
  State<StarBar> createState() => _StarBarState();
}

class _StarBarState extends State<StarBar> {
  void _updateByDx(double dx, double totalWidth) {
    final double starWidth = widget.size + widget.gap;
    // Map dx based on text direction: in RTL clicking right should decrease
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final double logicalDx = isRtl ? (totalWidth - dx) : dx;
    // Determine star index and whether left/right half
    int starIndex = (logicalDx / starWidth).floor();
    starIndex = starIndex.clamp(0, 4);
    final localXWithinStar = logicalDx - (starIndex * starWidth);
    final half = localXWithinStar < (starWidth / 2) ? 0.5 : 1.0;
    double candidate = (starIndex + half).toDouble();
    // Toggle behavior: if tapping the same value, lower to previous step
    if ((widget.value - candidate).abs() < 0.001) {
      candidate = half == 1.0 ? starIndex.toDouble() : (starIndex - 0.5).clamp(0.0, 5.0);
    }
    final double value = candidate.clamp(0.0, 5.0);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final whole = widget.value.floor();
    final hasHalf = (widget.value - whole) >= 0.5 && widget.value < 5;
    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        Color color;
        if (i < whole) {
          icon = Icons.star;
          color = widget.activeColor;
        } else if (i == whole && hasHalf) {
          icon = Icons.star_half;
          color = widget.activeColor;
        } else {
          icon = Icons.star_border;
          color = widget.inactiveColor;
        }
        return Padding(
          padding: EdgeInsetsDirectional.only(start: i == 0 ? 0 : widget.gap),
          child: Icon(icon, size: widget.size, color: color),
        );
      }),
    );

    if (widget.readOnly) return row;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (d) {
        final totalWidth = context.size?.width ?? (widget.size * 5 + widget.gap * 4);
        _updateByDx(d.localPosition.dx, totalWidth);
      },
      onHorizontalDragUpdate: (d) {
        final totalWidth = context.size?.width ?? (widget.size * 5 + widget.gap * 4);
        _updateByDx(d.localPosition.dx, totalWidth);
      },
      child: row,
    ).withPressFX();
  }
}


