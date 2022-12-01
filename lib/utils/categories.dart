import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/screens/vendor_services_screen.dart';

import '../theme/theme.dart';

class MyCatagories extends StatefulWidget {
  const MyCatagories({Key? key}) : super(key: key);

  @override
  State<MyCatagories> createState() => _MyCatagoriesState();
}

class _MyCatagoriesState extends State<MyCatagories> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong! ${snapshot.error}");
        } else if (snapshot.hasData) {
          if (snapshot.data!.docs.isNotEmpty) {
            return SizedBox(
              height: 75,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final categoryName = snapshot.data!.docs[index]['cateName'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => VendorServiceScreen(
                              category: categoryName,
                            ));
                      },
                      child: Container(
                        width: 75,
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          border: Border.all(
                            color: colorPrimary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const Icon(
                              //   Icons.restaurant,
                              //   size: 20,
                              // ),
                              Text(
                                categoryName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
    );
  }
}
