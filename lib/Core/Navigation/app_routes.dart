import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String digitalTwinRoute = '/digital-twin';
const String smartTrainingRoute = '/smart-training';
const String smartTrainingCoursesRoute = '/smart-training/courses';
const String assistantRoute = '/assistant';
const String perf360Route = '/performance-360';
const String profilePersonalInfoRoute = '/profile/personal-info';

extension AppRoutesExt on BuildContext {
  void goDigitalTwin() => GoRouter.of(this).push(digitalTwinRoute);
  void goSmartTraining() => GoRouter.of(this).push(smartTrainingRoute);
  void goSmartTrainingCourses() => GoRouter.of(this).push(smartTrainingCoursesRoute);
  void goAssistant() => GoRouter.of(this).go('/?tab=2');
  void goPerf360() => GoRouter.of(this).push(perf360Route);
  void goProfilePersonalInfo() => GoRouter.of(this).push(profilePersonalInfoRoute);
}


