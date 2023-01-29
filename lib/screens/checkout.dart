// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/services/cloud_controller.dart';
import 'package:user_app/utils/appbar.dart';
import 'package:user_app/widgets/elevated_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

import '../utils/bottom_appbar.dart';

class CheckoutScreen extends StatefulWidget {
  final String name;
  final String amount;
  // final String capacity;
  // final String date;
  final String serviceId;

  const CheckoutScreen({
    super.key,
    required this.name,
    // required this.date,
    required this.amount,
    // required this.capacity,
    required this.serviceId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Map<String, dynamic>? paymentIntentData;
  List<String> dates = [];
  bool isPaymentDone = false;

  @override
  Widget build(BuildContext context) {
    dynamic data = Get.arguments;
    dates.add(data[0]);
    return Scaffold(
      appBar: MyAppBar(title: "Checkout Screen"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isPaymentDone
            ? const Center(
                child: Icon(
                  Icons.done_all_rounded,
                  size: 75.00,
                  color: Colors.green,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20.00,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '1600 Amphitheatre Pkwy, Mountain View, CA 94043, United States',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Text(
                        'Date and Time',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      data[0].toString(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 5),
                      child: Text(
                        'Package Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Name'),
                        Text('People'),
                        Text('Amount'),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFF0F0F0F),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.name),
                        Text(data[1]+" x "+data[2]),
                        Text(widget.amount.toString()),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFF0F0F0F),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rs. ${widget.amount}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    MyElevatedButton(
                      title: 'Pay Cash',
                      onPress: () {},
                    ),
                    MyElevatedButton(
                      title: 'Pay by Card',
                      onPress: () async {
                        await makePayment();
                      },
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData = await createPaymentIntent(widget.amount, 'PKR');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                style: ThemeMode.dark,
                merchantDisplayName: 'Awais Gill'),
          )
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      log('exception:$e $s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        log('payment intent${paymentIntentData!['id']}');
        log('payment intent${paymentIntentData!['client_secret']}');
        log('payment intent${paymentIntentData!['amount']}');
        log('payment intent$paymentIntentData');

        paymentIntentData = null;
        CloudController.instance.postBookingDetailsToFirestore(
            serviceId: widget.serviceId,
            status: 'Paid',
            amount: widget.amount,
            bookingDates: dates);
        setState(() {
          isPaymentDone = true;
        });
      }).onError((error, stackTrace) {
        log('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      log('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      log('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      log(body.toString());
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51M9yITDgo9R9xZCUK6I5KYCIRuMXGA1HzX8tcrqCCDB7oAKPMVTJ3QJXGBNxaPbPQ4oMCwkuulkQ7w0DqNKLXrMH00UORBMV5a',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      log('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      log('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}
