import 'package:user_app/models/user_model.dart';

class BookedServiceModel {
  String? id;
  String? bookedService; //FIXME: type of BusinessModel
  List<DateTime>? bookedDates;
  UserModel? bookedBy;

  BookedServiceModel({
    this.id,
    this.bookedDates,
    this.bookedService,
    this.bookedBy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookedDates': bookedDates,
      'bookedService': bookedService,
      'bookedBy': bookedBy?.toMap(),
    };
  }

  factory BookedServiceModel.fromMap(map) {
    return BookedServiceModel(
      id: map['id'],
      bookedDates: map['bookedDates'],
      bookedService: map['bookedService'],
      bookedBy: map['bookedBy'],
    );
  }
}
