class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? phoneNo;
  String? profileUrl;
  String? gender;
  DateTime? joiningDate;
  bool? isActive;

  UserModel({
    this.uid,
    this.fullname,
    this.email,
    this.phoneNo,
    this.gender,
    this.joiningDate,
    this.profileUrl,
    this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'fullname': fullname,
      'email': email,
      'phoneNo': phoneNo,
      'gender': gender,
      'joiningDate': joiningDate,
      'profileUrl': profileUrl,
      'isActive': isActive,
    };
  }

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullname: map['fullname'],
      phoneNo: map['phoneNo'],
      gender: map['gender'],
      joiningDate: map['joiningDate'],
      profileUrl: map['profileUrl'],
      isActive: map['isActive'],
    );
  }
}
