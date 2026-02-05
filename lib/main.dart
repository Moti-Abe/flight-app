import 'package:flutter/material.dart';
import 'navigation/bottom_nav.dart';
import 'package:get/get.dart';
import 'pages/account/controllers/setting_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = Get.put(SettingsController());
  settingsController.loadSettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: BottomNav(),
    );
  }
}
