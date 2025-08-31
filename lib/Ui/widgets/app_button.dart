import 'package:flutter/material.dart';
import '../Common/press_fx.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final BorderRadius? radius;
  final Color? color;

  const AppButton({super.key, required this.label, this.onPressed, this.loading = false, this.height = 48, this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: radius ?? BorderRadius.circular(12)),
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
            : Text(label),
      ),
    ).withPressFX();
  }
}


