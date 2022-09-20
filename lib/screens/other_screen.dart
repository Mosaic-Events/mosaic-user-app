import 'package:flutter/material.dart';

class OtherScreen extends StatelessWidget {
  const OtherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Screen'),
      ),
      body: Center(
        child: Card(
          child: Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              child: const Text('Other Screen')),
        ),
      ),
    );
  }
}