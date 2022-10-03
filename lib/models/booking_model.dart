import 'package:user_app/models/user_model.dart';

class BookedServiceModel {
  String? id;
  String? bookedBy;
  String? bookedService;
  List<DateTime>? bookedDates;
  UserModel? user;

  BookedServiceModel({
    this.id,
    this.bookedBy,
    this.bookedDates,
    this.bookedService,
    this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookedBy': bookedBy,
      'bookedDates': bookedDates,
      'bookedService': bookedService,
      'user': user?.toMap(),
    };
  }

  // factory BookedServiceModel.fromMap(map) {
  //   return BookedServiceModel(
  //     id: map['id'],
  //     bookedDates: map['bookedDates'],
  //     bookedBy: map['bookedBy'],
  //     bookedService: map['bookedService'],
  //   );
  // }
}
