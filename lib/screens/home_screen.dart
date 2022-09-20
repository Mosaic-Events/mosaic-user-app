import 'package:flutter/material.dart';

import '../utils/appbar.dart';
import 'other_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home Screen',
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Other Screen'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OtherScreen()));
          },
        ),
      ),
    );
  }
}
