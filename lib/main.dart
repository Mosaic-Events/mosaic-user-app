import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/services/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      // Theme mode depends on device settings at the beginning
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 50), () {});
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/defaults/logo.png"),
          )),
        ),
      ),
    );
  }
}
