import 'package:flutter/material.dart';

import '../utils/appbar.dart';
import '../utils/bottom_appbar.dart';
import '../utils/categories.dart';
import '../utils/heading.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();
  bool showBottomAppBar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home Screen',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(
          controller: _scrollController,
          children: [
            // Account Info

            // Top row
            const MyHeading(title: "Promotions"),

            // Top Banner
            Container(
              height: 150,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://raw.githubusercontent.com/trainingtuts/mosaic_event/master/assets/images/image_1.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Categories Heading
            const MyHeading(title: "Categories"),

            // Catagories
            const MyCatagories(),

            // Trending Heading
            const MyHeading(title: "Trending"),

            // Carousel
            // MyCarousel(),
          ],
        ),
      ),
      // BottomAppBar
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
