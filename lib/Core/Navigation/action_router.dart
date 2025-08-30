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
    if (l == 'تقييم 360' || l == 'تقييم الأداء 360' || l == '360°') {
      context.goPerf360();
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

class Perf360LinkButton extends StatelessWidget {
  const Perf360LinkButton({super.key, this.label = 'تقييم 360'});
  final String label;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => ActionRouter.openByLabel(context, label), child: Text(label));
  }
}


