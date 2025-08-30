import 'package:flutter/material.dart';
import 'app_routes.dart';

class ActionRouter {
  static bool openByLabel(BuildContext context, String label) {
    final l = label.trim();
    if (l == 'التوأم الرقمي' || l == 'Digital Twin' || l == 'الرؤى الذكية') {
      context.goDigitalTwin();
      return true;
    }
    if (l == 'التدريب الذكي' || l == 'Smart Training') {
      context.goSmartTraining();
      return true;
    }
    return false;
  }
}

class TwinLinkButton extends StatelessWidget {
  const TwinLinkButton({super.key, this.label = 'التوأم الرقمي'});
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => ActionRouter.openByLabel(context, label), child: Text(label));
  }
}


