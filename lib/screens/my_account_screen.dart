import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_controller.dart';
import '../utils/appbar.dart';
import '../utils/view_text_field.dart';
import '../widgets/profile_pic.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    String password = "123456"; // FIXME:

    return Scaffold(
      appBar: MyAppBar(
        title: "My Account",
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 3));
          if (user != null) {
            // await user!.reload();
            user = FirebaseAuth.instance.currentUser;
          }
        },
        child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                const ProfilePic(),
                const SizedBox(height: 20),
                ViewTextField(
                  leading: Icons.account_circle,
                  title: user!.displayName.toString(),
                ),
                ViewTextField(
                  leading: Icons.email_outlined,
                  title: user.email.toString(),
                ),
                ViewTextField(
                  leading: Icons.check,
                  title: 'Verified: ${user.emailVerified}',
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () {
                      if (user!.emailVerified == false) {
                        AuthController.instance.sendEmailVerifyLink();
                      } else {
                        return;
                      }
                    },
                    // onPressed: null,
                    child: const Text('Verify Email'),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
                  child: ElevatedButton(
                    onPressed: () {
                      AuthController.instance
                          .deleteUser(user!.email!, password);
                    },
                    child: const Text('Delete User'),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
