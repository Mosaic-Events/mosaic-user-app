// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:user_app/utils/appbar.dart';
import 'package:user_app/utils/bottom_appbar.dart';
import 'package:user_app/widgets/elevated_button.dart';

import '../screens/checkout.dart';

class BookingForm extends StatefulWidget {
  final name;
  final price;
  final id;
  const BookingForm({
    super.key,
    required this.name,
    required this.price,
    required this.id,
  });

  @override
  State<BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController capacityController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    // dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  // @override
  @override
  Widget build(BuildContext context) {
    String formattedDate;
    return Scaffold(
      appBar: MyAppBar(title: "Booking Detail"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: capacityController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  RegExp regex = RegExp(r'^.{2,}$');
                  if (value!.isEmpty) {
                    return "Please Enter Capacity";
                  }
                  if (!regex.hasMatch(value)) {
                    return "Enter minimum 2 Character";
                  }
                  return null;
                },
                onSaved: (value) {
                  capacityController.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.people),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Capacity",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller:
                    dateController, //editing controller of this TextField
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date", //label text of field
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate: DateTime(
                          2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    formattedDate = DateFormat('yyyy-MM-dd').format(
                        pickedDate); // format date in required form here we use yyyy-MM-dd
                    log(formattedDate); //formatted date output using intl package =>  2022-07-04
                    setState(() {
                      dateController.text = formattedDate;
                    });
                  } else {
                    log("Date is not selected");
                  }
                },
              ),
              MyElevatedButton(
                title: "Checkout",
                onPress: () {
                  if (formKey.currentState!.validate()) {
                    var amount = int.parse(widget.price) *
                        int.parse(capacityController.text);
                    Get.to(
                      () => CheckoutScreen(
                        name: widget.name,
                        amount: amount.toString(),
                        capacity: capacityController.text,
                        serviceId: widget.id,
                      ),
                      arguments: [dateController.text],
                    );
                    dateController.clear();
                    capacityController.clear();
                  }
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
