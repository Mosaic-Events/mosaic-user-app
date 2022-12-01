// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:user_app/utils/appbar.dart';
import 'package:user_app/utils/bottom_appbar.dart';
import 'package:user_app/widgets/elevated_button.dart';

import '../widgets/my_loading_widget.dart';

class BiddingDetail extends StatelessWidget {
  final biddingId;
  const BiddingDetail({
    Key? key,
    this.biddingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Bidding Details'),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('bidding_details')
            .doc(biddingId)
            .get(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          } else if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            final name = data['biddingService']['businessName'] ?? 'null';
            final bidBy = data['bidBy']['fullname'];
            final bidAmount = data['amount'];
            log(name.toString());
            log(bidBy.toString());
            log(bidAmount.toString());

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Service Name: $name'),
                    Text('Bid By: $bidBy'),
                    Text('Bid Amount: $bidAmount'),
                    const Divider(),
                    ButtonBar(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.redAccent, // Background color
                            ),
                            // onPressed: null,
                            child: const Text('Reject'),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.44,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: ElevatedButton(
                            onPressed: () {},
                            // onPressed: null,
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          }
          return const MyLoadingWidget();
        },
      ),
      bottomNavigationBar: const MyBottomAppBar(),
    );
  }

  timeToDate(List timestamps) {
    List<DateTime> dates = [];
    for (Timestamp timestamp in timestamps) {
      dates.add(timestamp.toDate());
    }
    return dates;
  }
}
