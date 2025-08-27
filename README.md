# new_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Unified dialog animations

Use `showAppDialog` from `lib/Core/Animations/app_dialog.dart` to open dialogs with the app's unified transitions (fade + scale with optional blur) and accessibility support (reduce motion). Example:

```dart
import 'package:new_app/Core/Animations/app_dialog.dart';

onPressed: () {
  showAppDialog(
    context: context,
    transition: AppDialogTransition.fadeScale,
    useBlur: false,
    builder: (_) => const MyDialogWidget(),
  );
}
```

Prefer `showAppDialog` over `showDialog` for new dialogs.