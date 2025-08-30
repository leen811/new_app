import 'package:flutter/material.dart';
import 'coming_soon_dialog.dart';
import 'coming_soon_sheet.dart';

class ComingSoon {
  static Future<void> show(BuildContext context, {required String featureName, IconData? icon}) async {
    final width = MediaQuery.of(context).size.width;
    if (width < 720) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ComingSoonSheet(featureName: featureName, icon: icon),
      );
    } else {
      await showDialog(
        context: context,
        barrierColor: Colors.black26,
        builder: (_) => ComingSoonDialog(featureName: featureName, icon: icon),
      );
    }
  }
}


