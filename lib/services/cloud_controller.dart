import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/user_model.dart';

class CloudController {
  static final CloudController instance = Get.find();
  
  Future postBookingDetailsToFirestore({
    required String serviceId,
    required List<DateTime> bookingDates,
  }) async {
    // 1. calling our firestore
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // 2. Get Current User
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      UserModel? user = UserModel(
        uid: currentUser.uid,
        fullname: currentUser.displayName,
        email: currentUser.email,
      );
      // 3. calling our model
      BookedServiceModel bookedServiceModel = BookedServiceModel();
      // 4. Writing Values
      final bookingId = 'booking_${DateTime.now().millisecondsSinceEpoch}';

      bookedServiceModel.id = bookingId;
      bookedServiceModel.bookedService = serviceId;
      bookedServiceModel.bookedDates = bookingDates;
      bookedServiceModel.bookedBy = user;
      // 5. sending values to DB
      await firebaseFirestore
          .collection("booking_details")
          .doc(bookingId)
          .set(bookedServiceModel.toMap())
          .whenComplete(() {
        log("Order successfully place wait for confirmation");
        Fluttertoast.showToast(
            msg: "Order successfully place wait for confirmation");
        Get.back();
      });
    }
  }
}
