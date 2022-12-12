import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:user_app/services/auth_controller.dart';
import 'package:user_app/theme/theme.dart';

import 'services/cloud_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51M9yITDgo9R9xZCUBSB9gYXvbp3JbgNG0XbfnImFdRxZIFwkNwVWgBpcIJkOcIf1PHc3DsS4FQKlzuQjBaElWp6a00hjB1aYHj';
  await Firebase.initializeApp().then((value) {
    Get.put(AuthController());
    Get.put(CloudController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: MyThemeData.lightTheme,
      darkTheme: MyThemeData.darkTheme,
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
