import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/view_text_field.dart';
import '../widgets/profile_pic.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

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
                user!.emailVerified.toString(),
              ),
              ViewTextField(
                leading: Icons.account_circle,
                title: user.displayName.toString(),
              ),
              ViewTextField(
                leading: Icons.email_outlined,
                title: user.email.toString(),
              ),
            ],
          )),
    );
  }
}
