import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/screens/vendor_services_screen.dart';
import 'package:user_app/utils/appbar.dart';
import 'package:user_app/utils/profile_menu.dart';
import 'package:user_app/utils/view_text_field.dart';

import '../utils/bottom_appbar.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Categories'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text("Something went wrong! ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("Loading..."),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return ProfileMenu(
                title: data['cateName'],
                press: () => Get.to(
                  () => VendorServiceScreen(
                    category: data['cateName'],
                  ),
                ),
                trailing: Icons.arrow_forward,
              );
            }).toList(),
          );
        },
      ),
      // BottomAppBar
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
