// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

import '../theme/theme.dart';
// import 'package:mosaic_event/screens/restaurants.dart';

class MyCatagories extends StatefulWidget {
  const MyCatagories({Key? key}) : super(key: key);

  @override
  State<MyCatagories> createState() => _MyCatagoriesState();
}

class _MyCatagoriesState extends State<MyCatagories> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 75,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: 75,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        border: Border.all(
                          color: colorPrimary,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.restaurant,
                              size: 20,
                            ),
                            Text(
                              "Restaurants",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
