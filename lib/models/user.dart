import 'dart:typed_data';

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  String uid;
  String email;
  String name;
  String type;
  bool isAdmin;
  bool isVerified;
  int games;
  Uint8List profileImage;

  UserData(
      {this.uid,
      this.email,
      this.name,
      this.type,
      this.isAdmin,
      this.isVerified,
      this.games,
      this.profileImage});
}
