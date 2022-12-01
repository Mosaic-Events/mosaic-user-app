import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  const MyElevatedButton({super.key, this.onPress, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10),
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(title),
      ),
    );
  }
}
