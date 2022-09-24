import 'package:flutter/material.dart';
import 'package:user_app/services/auth_controller.dart';

import '../utils/view_text_field.dart';
import '../widgets/profile_pic.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authController = AuthController.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const ProfilePic(),
              const SizedBox(height: 20),
              Text(
                authController!.emailVerified.toString(),
              ),
              ViewTextField(
                leading: Icons.account_circle,
                title: authController.displayName!,
              ),
              ViewTextField(
                leading: Icons.email_outlined,
                title: authController.email!,
              ),
            ],
          )),
    );
  }
}
