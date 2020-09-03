import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final Timestamp dateOfBirth;
  var favorite;

  UserProfile({this.dateOfBirth, this.favorite});
}
