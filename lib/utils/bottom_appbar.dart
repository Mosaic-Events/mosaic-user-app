import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../theme/theme.dart';

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
        color: MyColors.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: const Icon(Icons.home),
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ChatPage()));
              },
              icon: const Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => DiscountsPage()));
              },
              icon: const Icon(Icons.discount),
            ),
            IconButton(
              tooltip: "Notification",
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => NotificationsPage()));
              },
              icon: const Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => ProfileScreen()));
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
