import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/setting_service.dart';

class SettingsController extends GetxController {
  var language = "English".obs;
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    language.value = await SettingsStorage.loadLanguage();
    isDarkMode.value = await SettingsStorage.loadTheme();

    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void changeLanguage(String value) {
    language.value = value;
    SettingsStorage.saveLanguage(value);
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    SettingsStorage.saveTheme(value);

    Get.changeThemeMode(
      value ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
