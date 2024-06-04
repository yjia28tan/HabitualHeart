import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String _uid = '';
  String email;
  String? username;
  DateTime? birthDate;
  bool? dailyReminder;
  DateTime? reminderTime;

  // Getter for UID
  String get uid => _uid;

  // Setter for UID that notifies listeners when changed
  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  // Constructor
  UserModel({
    required String uid,
    required this.email,
    this.birthDate,
    required this.username,
    required this.dailyReminder,
    this.reminderTime,
  }) : _uid = uid;

  // Factory method to create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      birthDate: data['birthDate'] != null
          ? (data['birthDate'] as Timestamp).toDate()
          : null,
      dailyReminder: data['email'],
      reminderTime: data['reminderTime'] != null
          ? (data['reminderTime'] as Timestamp).toDate(): null,
    );
  }

  // Method to convert a UserModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'email': email,
      'username': username,
      'birthDate': birthDate,
      'dailyReminder': dailyReminder,
      'reminderTime': reminderTime,
    };
  }
}
