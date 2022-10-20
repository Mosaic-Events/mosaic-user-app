import 'package:flutter/material.dart';
import 'package:user_app/services/cloud_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    //form key
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                autofocus: true,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter email address";
                  }
                  if (!RegExp('[a-z0-9]+@[a-z]+.[a-z]{2,3}').hasMatch(value)) {
                    return "Please enter valid email address";
                  }
                  return null;
                },
                onSaved: (value) {
                  emailController.text = value!;
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Email Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                   CloudController.instance.resetPassword(
                        email: emailController.text.trim());
                  }
                },
                child: const Text('Reset Password'),
              )
            ],
          ),
        ),
      ),
    );
  }
}