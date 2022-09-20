import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('User App'),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
            icon: const Icon(Icons.brightness_4),
            onPressed: () {
              Get.isDarkMode
                  ? Get.changeTheme(ThemeData.light())
                  : Get.changeTheme(ThemeData.dark());
            })
      ],
    );
  }
}
