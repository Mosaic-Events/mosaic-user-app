// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:user_app/models/business_model.dart';
import 'package:user_app/models/user_model.dart';

class BookedServiceModel {
  String? id;
  String? bookingStatus;
  BusinessModel? bookedService;
  List<String>? bookedDates;
  UserModel? bookedBy;
  int? amount;
  int? people;

  BookedServiceModel({
    this.id,
    this.bookingStatus,
    this.bookedService,
    this.bookedDates,
    this.bookedBy,
    this.amount,
    this.people,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookingStatus': bookingStatus,
      'bookedService': bookedService?.toMap(),
      'bookedDates': bookedDates,
      'bookedBy': bookedBy?.toMap(),
      'amount': amount,
      'people': people,
    };
  }

  factory BookedServiceModel.fromMap(Map<String, dynamic> map) {
    return BookedServiceModel(
      id: map['id'] != null ? map['id'] as String : null,
      bookingStatus: map['bookingStatus'] != null ? map['bookingStatus'] as String : null,
      bookedService: map['bookedService'] != null ? BusinessModel.fromMap(map['bookedService'] as Map<String,dynamic>) : null,
      bookedDates: map['bookedDates'] != null ? List<String>.from((map['bookedDates'] as List<String>)) : null,
      bookedBy: map['bookedBy'] != null ? UserModel.fromMap(map['bookedBy'] as Map<String,dynamic>) : null,
      amount: map['amount'] != null ? map['amount'] as int : null,
      people: map['people'] != null ? map['people'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookedServiceModel.fromJson(String source) => BookedServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
