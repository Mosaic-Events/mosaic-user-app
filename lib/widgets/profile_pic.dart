// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/services/auth_controller.dart';
import 'package:user_app/theme/theme.dart';

import '../utils/upload_image.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usersCollection = AuthController.instance.usersCollection;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
      stream: usersCollection.doc(userId).snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundImage: data['profileUrl'] != null
                      ? NetworkImage("${data['profileUrl']}")
                      : const AssetImage("assets/defaults/logo.png")
                          as ImageProvider,
                ),
                Positioned(
                  right: -16,
                  bottom: 0,
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: BorderSide(color: Colors.white),
                        ),
                        backgroundColor: Color(0xFFF5F6F9),
                      ),
                      onPressed: () {
                        UploadImage.uploadProfileImage();
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: MyThemeData.iconColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
