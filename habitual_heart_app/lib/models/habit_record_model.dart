import 'package:cloud_firestore/cloud_firestore.dart';

class DailyHabitRecordModel {
  String userID;
  String habitsID;
  String dailyRecordID;
  Timestamp dateTime;
  String status;

  DailyHabitRecordModel({
    required this.userID,
    required this.habitsID,
    required this.dailyRecordID,
    required this.dateTime,
    required this.status,
  });

  factory DailyHabitRecordModel.fromMap(Map<String, dynamic> data) {
    return DailyHabitRecordModel(
      userID: data['userID'],
      habitsID: data['habitsID'],
      dailyRecordID: data['dailyRecordID'],
      dateTime: data['dateTime'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'habitsID': habitsID,
      'dailyRecordID': dailyRecordID,
      'dateTime': dateTime,
      'status': status,
    };
  }
}
