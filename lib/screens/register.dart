import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:user_app/screens/login.dart';
import 'package:user_app/services/auth_controller.dart';

import '../models/user_model.dart';

enum Gender { male, female, other }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Gender? _gender = Gender.male;
  final defaultImage = Image.asset('assets/default/default_pp.png');
  // auth
  final _auth = FirebaseAuth.instance;

  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? _gender;
  final _genderList = ['Male', 'Female', 'Other'];

  String? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    // fullname field
    final fullnameField = TextFormField(
      autofocus: true,
      controller: fullnameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return "Please enter your name";
        }
        if (!regex.hasMatch(value)) {
          return "Enter minimum 3 Character";
        }
        return null;
      },
      onSaved: (value) {
        fullnameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_circle),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Full Name",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // email field
    final emailField = TextFormField(
      autofocus: false,
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
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email Address",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // gender field
    final genderField = DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
      hint: const Text("Select Gender"),
      value: _gender,
      items: _genderList
          .map(
            (e) => DropdownMenuItem(value: e, child: Text(e)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _gender = value.toString();
        });
      },
      decoration: InputDecoration(
        // contentPadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Gender",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ));

    // phone no field
    final phoneNoField = IntlPhoneField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        counter: const Offstage(),
        labelText: 'Mobile Number',
        border: OutlineInputBorder(
          borderSide: const BorderSide(),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      showDropdownIcon: false,
      flagsButtonPadding: const EdgeInsets.only(left: 12),
      initialCountryCode: 'PK',
      onChanged: ((phone) {
        setState(() {
          _phoneNumber = phone.completeNumber;
        });
      }),
    );

    // password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return "Password is required for signup";
        }
        if (!regex.hasMatch(value)) {
          return "Please enter valid password(Min. 6 Character)";
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // confirmPassword field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (passwordController.text != value) {
          return "Password did not match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    // SignUp button
    final signupButton = Material(
      elevation: 5,
      color: Colors.blue,
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            AuthController.instance
                .createUserWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                )
                .then(
                  (value) => postUserDetailsToFirestore(),
                )
                .catchError((error) {
              Fluttertoast.showToast(msg: error!.message);
            });
          }
        },
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        child: const Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text("Create an account"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    fullnameField,
                    const SizedBox(height: 10),
                    emailField,
                    const SizedBox(height: 10),
                    phoneNoField,
                    passwordField,
                    const SizedBox(height: 10),
                    confirmPasswordField,
                    const SizedBox(height: 10),
                    genderField,
                    const SizedBox(height: 10),
                    signupButton,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  postUserDetailsToFirestore() async {
    // 1. calling our firestore
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    // 2. calling our user_model
    UserModel userModel = UserModel();
    // 3. writing values
    if (user != null) {
      userModel.uid = user.uid;
      userModel.fullname = fullnameController.text;
      userModel.email = user.email;
      userModel.phoneNo = _phoneNumber;
      userModel.gender = _gender;
      userModel.joiningDate = DateTime.now();
      // userModel.profileUrl = user.email;
      userModel.isActive = true;
      // 4. sending values to DB
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap())
          .whenComplete(
        () {
          var currentUserr = FirebaseAuth.instance.currentUser!;
          currentUserr.updateDisplayName(fullnameController.text);
          currentUserr.updateEmail(emailController.text);
        },
      ).whenComplete(() =>
              Fluttertoast.showToast(msg: "Account created successfully :)"));
    }
  }
}
