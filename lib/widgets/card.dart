// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class VendorServiceCard extends StatelessWidget {
  String title;
  String category;
  String uid;
  String imageUrl;
  String? price;
  String? description;

  final VoidCallback? onPress;
  VendorServiceCard({
    Key? key,
    required this.title,
    required this.category,
    required this.uid,
    required this.imageUrl,
    this.description,
    this.price,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image.network(imageUrl),
          ListTile(
            title: Text(title),
            subtitle: Text(
              uid,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_outline),
              onPressed: () {},
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                onPressed: () {
                  // Perform some action
                },
                child: const Text('ACTION 2'),
              ),
              // const Icon(Icons.favorite_outline),
              // const Icon(Icons.share),
            ],
          ),
        ],
      ),
    );
  }
}
