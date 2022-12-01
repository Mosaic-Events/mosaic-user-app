import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:user_app/models/business_model.dart';

import '../models/banquet_model.dart';
import '../models/bidding_model.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';

class CloudController {
  static final CloudController instance = Get.find();

  Future postBookingDetailsToFirestore({
    required String serviceId,
    required String status,
    required String amount,
    required List<String> bookingDates,
  }) async {
    // 1. calling our firestore
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // 2. Get Current User
    final currentUser = FirebaseAuth.instance.currentUser;
    // Getting Business details
    firebaseFirestore
        .collection('businesses')
        .doc(serviceId)
        .get()
        .then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      BusinessModel gettingBusinessModel = BusinessModel.fromMap(data);
      if (currentUser != null) {
        UserModel? user = UserModel(
          uid: currentUser.uid,
          fullname: currentUser.displayName,
          email: currentUser.email,
        );
        BusinessModel? bookedService = BusinessModel();
        bookedService.businessId = gettingBusinessModel.businessId;
        bookedService.businessName = gettingBusinessModel.businessName;
        bookedService.initialPrice = gettingBusinessModel.initialPrice;
        bookedService.businessCategory = gettingBusinessModel.businessCategory;
        bookedService.joiningDate = gettingBusinessModel.joiningDate;
        bookedService.images = gettingBusinessModel.images;
        bookedService.owner = gettingBusinessModel.owner;

        // 3. calling our model
        BookedServiceModel bookedServiceModel = BookedServiceModel();
        // 4. Writing Values
        final bookingId = 'booking_${DateTime.now().millisecondsSinceEpoch}';

        bookedServiceModel.id = bookingId;
        bookedServiceModel.amount = int.parse(amount);
        bookedServiceModel.bookingStatus = status;
        bookedServiceModel.bookedService = bookedService;
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
        });
      }
    });
  }

  Future postBiding({
    required String serviceId,
    required String uid,
    required String bid,
  }) async {
    // 1. calling our firestore
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // 2. Get Current User
    final currentUser = FirebaseAuth.instance.currentUser;

    // Getting Banquet details
    firebaseFirestore
        .collection('businesses')
        .doc(serviceId)
        .get()
        .then((DocumentSnapshot doc) async {
      final data = doc.data() as Map<String, dynamic>;
      BanquetModel gettingBanquetModel = BanquetModel.fromMap(data);
      if (currentUser != null) {
        UserModel? user = UserModel(
          uid: currentUser.uid,
          fullname: currentUser.displayName,
          email: currentUser.email,
        );

        log(gettingBanquetModel.name!);
        BusinessModel? biddedService = BusinessModel();
        biddedService.businessId = gettingBanquetModel.id;
        biddedService.businessName = gettingBanquetModel.name;
        biddedService.initialPrice = gettingBanquetModel.price;
        biddedService.businessCategory = gettingBanquetModel.category;
        biddedService.joiningDate = gettingBanquetModel.registrationDate;
        biddedService.images = gettingBanquetModel.images;
        biddedService.owner = gettingBanquetModel.owner;

        // 3. calling our model
        BiddingModel biddingModel = BiddingModel();
        // 4. Writing Values
        final biddingId = 'bidding_${DateTime.now().millisecondsSinceEpoch}';

        biddingModel.id = biddingId;
        biddingModel.amount = int.parse(bid);
        // biddingModel.biddingStatus = status;
        biddingModel.biddingService = biddedService;
        biddingModel.bidBy = user;
        // 5. sending values to DB
        await firebaseFirestore
            .collection("bidding_details")
            .doc(biddingId)
            .set(biddingModel.toMap())
            .whenComplete(() {
          Fluttertoast.showToast(msg: "You have Bid");
        });
      }
    });
  }

  toMillisecondsSinceEpoch(List<DateTime> dates) {
    List dates = [];
    for (DateTime date in dates) {
      dates.add(date.millisecondsSinceEpoch);
    }
    return dates;
  }

  Future resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .whenComplete(() {
        log('Password reset link sent');
        Fluttertoast.showToast(msg: 'Password reset link sent');
      });
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.code);
    }
  }
}
