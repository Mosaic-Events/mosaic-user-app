import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:user_app/screens/home_screen.dart';
import 'package:user_app/screens/promotion_screen.dart';
import 'package:user_app/widgets/show_dailog_box.dart';

import '../screens/profile_screen.dart';

class MyBottomAppBar extends StatefulWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);

  @override
  State<MyBottomAppBar> createState() => _MyBottomAppBarState();
}

class _MyBottomAppBarState extends State<MyBottomAppBar> {
  final ScrollController _scrollController = ScrollController();

  bool showBottomAppBar = true;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBottomAppBar = false;
        setState(() {});
      } else {
        showBottomAppBar = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: showBottomAppBar ? 60 : 0,
      curve: Curves.easeInOutSine,
      duration: const Duration(
        milliseconds: 800,
      ),
      child: BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  Get.offAll(() => HomeScreen());
                },
                icon: const Icon(Icons.home),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const PromotionScreen());
              },
              icon: const Icon(Icons.discount),
            ),
            IconButton(
              tooltip: "Notification",
              onPressed: () {
                Get.to(() => const ShowForm());
              },
              icon: const Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  Get.to(() => const ProfileScreen());
                },
                icon: const Icon(Icons.account_circle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
