import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String? displayName;
  String? photoURL;
  DateTime? birthDate;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    this.birthDate,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      birthDate: data['birthDate'] != null ? (data['birthDate'] as Timestamp)
          .toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'birthDate': birthDate,
    };
  }
}
