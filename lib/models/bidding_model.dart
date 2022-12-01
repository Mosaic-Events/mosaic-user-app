// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:user_app/models/business_model.dart';
import 'package:user_app/models/user_model.dart';

class BiddingModel {
  String? id;
  String? biddingStatus;
  BusinessModel? biddingService;
  UserModel? bidBy;
  int? amount;

  BiddingModel({
    this.id,
    this.biddingStatus,
    this.biddingService,
    this.bidBy,
    this.amount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'biddingStatus': biddingStatus,
      'biddingService': biddingService?.toMap(),
      'bidBy': bidBy?.toMap(),
      'amount': amount,
    };
  }

  factory BiddingModel.fromMap(Map<String, dynamic> map) {
    return BiddingModel(
      id: map['id'] != null ? map['id'] as String : null,
      biddingStatus: map['biddingStatus'] != null ? map['biddingStatus'] as String : null,
      biddingService: map['biddingService'] != null ? BusinessModel.fromMap(map['biddingService'] as Map<String,dynamic>) : null,
      bidBy: map['bidBy'] != null ? UserModel.fromMap(map['bidBy'] as Map<String,dynamic>) : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BiddingModel.fromJson(String source) => BiddingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
