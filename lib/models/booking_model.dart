class BookedServiceModel {
  String? uid;
  String? bookedBy;
  List? bookedDates;
  String? bookedService;

  BookedServiceModel({
    this.uid,
    this.bookedBy,
    this.bookedDates,
    this.bookedService,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'bookedBy': bookedBy,
      'bookedDates': bookedDates,
      'bookedService': bookedService,
    };
  }

  factory BookedServiceModel.fromMap(map) {
    return BookedServiceModel(
      uid: map['uid'],
      bookedDates: map['bookedDates'],
      bookedBy: map['bookedBy'],
      bookedService: map['bookedService'],
    );
  }
}
