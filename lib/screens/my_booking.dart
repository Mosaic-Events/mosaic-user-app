import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/models/business_model.dart';
import 'package:user_app/models/user_model.dart';
import 'package:user_app/screens/booking_detail_screen.dart';
import 'package:user_app/utils/appbar.dart';

import '../utils/bottom_appbar.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'My Bookings'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking_details')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final bookingId = snapshot.data!.docs[index]['id'];
                  final bookedBy = snapshot.data!.docs[index]['bookedBy'];
                  final bookedService =
                      snapshot.data!.docs[index]['bookedService'];
                  final UserModel user = UserModel.fromMap(bookedBy);
                  final BusinessModel service =
                      BusinessModel.fromMap(bookedService);

                  return InkWell(
                    child: ListTile(
                      title: Text('${service.businessName}'),
                      subtitle: Text(bookingId + " | " + user.fullname),
                    ),
                    onTap: () =>
                        Get.to(() => BookingDetail(bookingId: bookingId)),
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, Something went wrong.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
