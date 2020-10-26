import 'dart:typed_data';

class TeamList {
  String grade;
  List players;

  TeamList({this.grade, this.players});
}

class Player {
  bool isDefault;
  String id;
  String name;
  String status;
  // String profileImage;
  Uint8List profileImage;

  Player({this.isDefault, this.id, this.name, this.status, this.profileImage});
}
