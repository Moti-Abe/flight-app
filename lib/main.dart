import 'package:expedia/navigation/bottom_nav.dart';
// import 'package:expedia/pages/home/auth/auth_controller.dart';
// import 'package:expedia/pages/home/auth/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/account/controllers/setting_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final settingsController = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: settingsController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        // home: Scaffold(body: Center(child: CircularProgressIndicator())),
        // home: SignInPage(),
        home: BottomNav(),
      ),
    );
  }
}
