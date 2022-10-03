import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:user_app/models/booking_model.dart';
import 'package:user_app/screens/date_picker_screen.dart';
import '../utils/appbar.dart';
import '../widgets/my_loading_widget.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  TextEditingController bidController = TextEditingController();
  // form key
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Service Detail Screen',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('businesses')
              .doc(widget.serviceId)
              .get(),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            } else if (snapshot.hasData && !snapshot.data!.exists) {
              return const Text("Document does not exist");
            } else if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['businessName'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data['owner'],
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: const Text('Book Now'),
                        onPressed: () {
                          Get.to(() => const DatePicker())!.then((result) {
                            if (result != null) {
                              log('result: $result');
                              postBookingDetailsToFirestore(
                                  serviceId: widget.serviceId,
                                  bookingDates: result);
                            }
                          });
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Bid'),
                        onPressed: () async {
                          final bid = await openDialog();
                          if (bid != null) {
                            log(bid);
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  // Image GridView
                  Expanded(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 2.0,
                          mainAxisSpacing: 2.0,
                        ),
                        itemCount: data['images'].length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.0),
                              image: DecorationImage(
                                  image: NetworkImage(data['images'][index]),
                                  fit: BoxFit.fill),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
            return const MyLoadingWidget();
          },
        ),
      ),
    );
  }

  Future<String?> openDialog() {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Make your Bid'),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: bidController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              RegExp regex = RegExp(r'^\d+$');
              if (value!.isEmpty) {
                return "Please enter bidding amount";
              }
              if (!regex.hasMatch(value)) {
                return "Enter Only Digits";
              }
              return null;
            },
            decoration: const InputDecoration(hintText: 'Bid Price'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              close();
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                submit();
              }
            },
            child: const Text('Submit'),
          )
        ],
      ),
    );
  }

  void submit() {
    Navigator.of(context).pop(bidController.text);
    bidController.clear();
  }

  void close() {
    Navigator.of(context).pop();
  }

  Future postBookingDetailsToFirestore(
      {required String serviceId, required List<DateTime> bookingDates}) async {
    // 1. calling our firestore
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // 2. Get Current User
    User? user = FirebaseAuth.instance.currentUser;
    // 3. calling our model
    BookedServiceModel bookedServiceModel = BookedServiceModel();
    // 4. Writing Values
    if (user != null) {
      // For unique name
      final bookingId = 'booking_${DateTime.now().millisecondsSinceEpoch}';
      bookedServiceModel.id = bookingId;
      bookedServiceModel.bookedBy = user.uid;
      bookedServiceModel.bookedService = serviceId;
      bookedServiceModel.bookedDates = bookingDates;
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
