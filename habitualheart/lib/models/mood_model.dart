import 'package:cloud_firestore/cloud_firestore.dart';

class MoodModel {
  String userID;
  String moodID;
  Timestamp datetime;
  String mood;
  String? description;

  MoodModel({
    required this.userID,
    required this.moodID,
    required this.datetime,
    required this.mood,
    this.description,
  });

  factory MoodModel.fromMap(Map<String, dynamic> data) {
    return MoodModel(
      userID: data['userID'],
      moodID: data['moodID'],
      datetime: data['datetime'],
      mood: data['mood'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'moodID': moodID,
      'datetime': datetime,
      'mood': mood,
      'description': description,
    };
  }
}
