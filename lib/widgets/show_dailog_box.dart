// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:user_app/utils/appbar.dart';
import 'package:flutter/services.dart';

import '../utils/bottom_appbar.dart';

class ShowForm extends StatefulWidget {
  const ShowForm({super.key});

  @override
  State<ShowForm> createState() => _ShowFormState();
}

class _ShowFormState extends State<ShowForm> {
  TextEditingController bidController = TextEditingController();
  // form key
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Texting'),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final bid = await openDialog();
            if (bid != null) {
              log(bid);
            }
          },
          child: Text('Show Form'),
        ),
      ),
      bottomNavigationBar: MyBottomAppBar(),
    );
  }

  void submit() {
    Navigator.of(context).pop(bidController.text);
    bidController.clear();
  }

  void close() {
    Navigator.of(context).pop();
  }

  Future<String?> openDialog() {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Make your Bid'),
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
            decoration: InputDecoration(hintText: 'Bid Price'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              close();
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                submit();
              }
            },
            child: Text('Submit'),
          )
        ],
      ),
    );
  }
}
