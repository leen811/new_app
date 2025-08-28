import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String digitalTwinRoute = '/digital-twin';

extension AppRoutesExt on BuildContext {
  void goDigitalTwin() => GoRouter.of(this).push(digitalTwinRoute);
}


