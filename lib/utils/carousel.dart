// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCarousel extends StatefulWidget {
  const MyCarousel({Key? key}) : super(key: key);

  @override
  State<MyCarousel> createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("carousel_banners").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong!");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // fetching data
        final List carouselUrl = [];
        snapshot.data!.docs.map((DocumentSnapshot document) {
          Map bannerUrl = document.data() as Map;
          carouselUrl.add(bannerUrl);
        }).toList();
        return CarouselSlider(
          options: CarouselOptions(
            height: 150.0,
            enlargeCenterPage: true,
            viewportFraction: 1,
            autoPlay: true,
            aspectRatio: 16 / 9,
          ),
          items: carouselUrl.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imagePath['carousel_banners_url']),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
