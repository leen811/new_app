import 'package:flutter/material.dart';
import '../Common/press_fx.dart';

class EmptyView extends StatelessWidget {
  final String message;
  const EmptyView({super.key, this.message = 'لا توجد بيانات'});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message));
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: onRetry, child: const Text('إعادة المحاولة')).withPressFX(),
        ],
      ),
    );
  }
}


