import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_app/models/user_model.dart';
import 'package:user_app/screens/date_picker_screen.dart';
import 'package:user_app/services/cloud_controller.dart';

import '../utils/appbar.dart';
import '../widgets/my_loading_widget.dart';
import 'image_view.dart';

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
              final owner = data['owner'];
              final images = data['images'];
              final UserModel user = UserModel.fromMap(owner);
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
                    user.fullname ?? "null",
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
                              CloudController.instance
                                  .postBookingDetailsToFirestore(
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
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, index) {
                          return InkWell(
                            onTap: () => Get.to(() => GalleryWidget(
                                  urls: images,
                                  index: index,
                                )),
                            child: Container(
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(0.0),
                                image: DecorationImage(
                                    image: NetworkImage(images[index]),
                                    fit: BoxFit.fill),
                              ),
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
}
