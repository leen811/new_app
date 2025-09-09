import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ar'));

  static const String _prefsKey = 'app_locale'; // 'ar' | 'en'

  Future<void> loadInitial() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? code = prefs.getString(_prefsKey);
      if (code == 'en') {
        emit(const Locale('en'));
      } else {
        emit(const Locale('ar'));
      }
    } catch (_) {
      // Fallback to Arabic on any error to keep app usable
      emit(const Locale('ar'));
    }
  }

  Future<void> setArabic() async {
    await _setLocaleCode('ar');
  }

  Future<void> setEnglish() async {
    await _setLocaleCode('en');
  }

  Future<void> _setLocaleCode(String code) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, code);
      emit(Locale(code));
    } catch (_) {
      emit(Locale(code));
    }
  }
}
