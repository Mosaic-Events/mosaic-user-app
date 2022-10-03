class BookedServiceModel {
  String? id;
  String? bookedBy;
  String? bookedService;
  List<DateTime>? bookedDates;

  BookedServiceModel({
    this.id,
    this.bookedBy,
    this.bookedDates,
    this.bookedService,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookedBy': bookedBy,
      'bookedDates': bookedDates,
      'bookedService': bookedService,
    };
  }

  factory BookedServiceModel.fromMap(map) {
    return BookedServiceModel(
      id: map['id'],
      bookedDates: map['bookedDates'],
      bookedBy: map['bookedBy'],
      bookedService: map['bookedService'],
    );
  }
}
