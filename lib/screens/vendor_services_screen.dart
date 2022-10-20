// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/utils/appbar.dart';
import 'package:user_app/utils/bottom_appbar.dart';

import '../models/user_model.dart';
import '../widgets/my_card.dart';

class VendorServiceScreen extends StatelessWidget {
  String? category;
  VendorServiceScreen({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    businessStream() {
      var stream;
      if (category != null) {
        stream = FirebaseFirestore.instance
            .collection('businesses')
            .where('businessCategory', isEqualTo: category)
            .snapshots();
      } else {
        stream =
            FirebaseFirestore.instance.collection('businesses').snapshots();
      }
      return stream;
    }

    return Scaffold(
      appBar: MyAppBar(title: 'Service Screen'),
      body: StreamBuilder<QuerySnapshot>(
        stream: businessStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, index) {
                  final businessName =
                      snapshot.data!.docs[index]['businessName'];
                  final businessId = snapshot.data!.docs[index]['businessId'];
                  final owner = snapshot.data!.docs[index]['owner'];
                  var user = UserModel.fromMap(owner);
                  final initialPrice =
                      snapshot.data!.docs[index]['initialPrice'];
                  final imageUrl = snapshot.data!.docs[index]['images'];
                  return MyCard(
                    id: businessId,
                    title: businessName,
                    price: initialPrice,
                    description: user.fullname!,
                    imageUrl: imageUrl,
                    onPress: () {},
                  );
                },
              );
            } else {
              return const Center(
                  child: Text(
                "Sorry, There is no data right now.\nPlease add some data first.",
                style: TextStyle(
                  fontSize: 20,
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
