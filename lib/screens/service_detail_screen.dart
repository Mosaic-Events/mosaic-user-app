import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:user_app/form/booking_form.dart';
import 'package:user_app/models/user_model.dart';
import 'package:user_app/services/cloud_controller.dart';
import 'package:user_app/utils/bottom_appbar.dart';

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
    final uid = FirebaseAuth.instance.currentUser!.uid;
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
              final name = data['businessName'];
              final owner = data['owner'];
              final images = data['images'];
              final capacity = data['capacity'];
              final price = data['initialPrice'];
              final UserModel user = UserModel.fromMap(owner);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
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
                  Text(
                    "Capacity: $capacity",
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
                          Get.to(() => BookingForm(
                                name: name,
                                price: price,
                                id: widget.serviceId,
                              ));
                        },
                      ),
                      ElevatedButton(
                        child: const Text('Bid'),
                        onPressed: () async {
                          final bid = await openDialog();
                          if (bid != null) {
                            CloudController.instance.postBiding(
                                serviceId: widget.serviceId,
                                uid: uid,
                                bid: bid);
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
      bottomNavigationBar: const MyBottomAppBar(),
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
