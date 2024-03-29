import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:user_app/screens/home_screen.dart';

import '../screens/login.dart';

class AuthController extends GetxController {
  static final AuthController instance = Get.find();

  late Rx<User?> _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late UserCredential _userCredential;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(_firebaseAuth.currentUser);
    _user.bindStream(_firebaseAuth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      log('Goto Login Screen');
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  Future createUserWithEmailAndPassword(String email, password) async {
    try {
      _userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'About User',
        'User message',
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Account creation failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      log(e.toString());
    }
  }

  void signInUserWithEmailAndPassword(String email, password) async {
    try {
      _userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'About Login',
        'Login message',
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Account login failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      log(e.toString());
    }
  }

  void logOut() async {
    await _firebaseAuth.signOut();
  }

  Future deleteUser(String email, String password) async {
    try {
      UserCredential newCredential =
          await _userCredential.user!.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      newCredential.user!.delete();
      log('User deleted');
    } catch (e) {
      Get.snackbar(
        'About Delete User',
        'delete message',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        titleText: const Text(
          'Account deletion failed',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
      log("${e.toString()} reauth");
    }
  }

  Future sendEmailVerifyLink() async {
    try {
      if (!_userCredential.user!.emailVerified) {
        await _userCredential.user!
            .sendEmailVerification()
            .whenComplete(() => Fluttertoast.showToast(msg: 'Link successfully sent'));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // FirebaseFirestore

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference get usersCollection =>
      _firebaseFirestore.collection('users');

  CollectionReference get businessCollection =>
      _firebaseFirestore.collection('businesses');
}
