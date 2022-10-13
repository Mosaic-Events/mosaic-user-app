import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/screens/promotion_screen.dart';
import 'package:user_app/screens/vendor_services_screen.dart';

import '../utils/appbar.dart';
import '../utils/bottom_appbar.dart';
import '../utils/carousel.dart';
import '../utils/categories.dart';
import '../utils/heading.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  bool showBottomAppBar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Home Screen',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            // controller: _scrollController,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Account Info

              // Top row
              MyHeading(
                title: "Promotions",
                onPress: () {
                  Get.to(() => const PromotionScreen());
                },
              ),

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
              MyHeading(
                title: "Trending",
                onPress: () {
                  Get.to(() => const VendorServiceScreen());
                },
              ),

              // Carousel
              const MyCarousel(),
            ],
          ),
        ),
      ),
      // BottomAppBar
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }
}
