import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  // Upload Profile Image
  static uploadProfileImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    File? image;
    final imagePicker = ImagePicker();
    String? profileDownloadURL;

    final selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (selectedImage != null) {
      image = File(selectedImage.path);
    } else {
      Fluttertoast.showToast(msg: "No File selected");
    }

    // For unique name
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference = FirebaseStorage.instance
        .ref()
        .child('users_profile_pic')
        .child(userId)
        .child("img_$imgId");

    await reference.putFile(image!);
    profileDownloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .update({'profileUrl': profileDownloadURL})
        .whenComplete(() => {
              currentUser!.updatePhotoURL(profileDownloadURL),
              Fluttertoast.showToast(msg: "Profile Uploaded"),
            })
        .catchError(
          (e) {
            Fluttertoast.showToast(msg: e.toString());
            log(e.toString());
          },
        );
  }
}
