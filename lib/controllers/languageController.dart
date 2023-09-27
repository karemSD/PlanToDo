import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constans.dart';
import '../models/lang/lang.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }
  Locale _locale = Locale(AppConstants.languages[1].languageCode,
      AppConstants.languages[1].countryCode);
  Locale get locale => _locale;
  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;
  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;
  Future<void> loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) ??
        AppConstants.languages[1].languageCode);
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  Future<void> setLanguage({required Locale locale}) async {
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(locale: _locale);
    update();
  }

  void setSelectIndex({required int index}) {
    _selectedIndex = index;
    update();
  }

  Future<void> saveLanguage({required Locale locale}) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode!);
  }
}
