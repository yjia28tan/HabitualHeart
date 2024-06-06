import 'package:cloud_firestore/cloud_firestore.dart';

class HabitRecordModel {
  String habitRecordID;
  String habitID;
  DateTime date;
  List<Record> records;
  bool status;
  int streak;

  HabitRecordModel({
    required this.habitRecordID,
    required this.habitID,
    required this.date,
    required this.records,
    required this.status,
    required this.streak,
  });

  factory HabitRecordModel.fromMap(Map<String, dynamic> data) {
    return HabitRecordModel(
      habitRecordID: data['habitRecordID'],
      habitID: data['habitID'],
      date: DateTime.parse(data['date']),
      records: (data['records'] as List).map((record) => Record.fromMap(record)).toList(),
      status: data['status'],
      streak: data['streak'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitRecordID': habitRecordID,
      'habitID': habitID,
      'date': date.toIso8601String(),
      'records': records.map((record) => record.toMap()).toList(),
      'status': status,
      'streak': streak,
    };
  }
}

class Record {
  String recordID;
  String time;

  Record({
    required this.recordID,
    required this.time,
  });

  factory Record.fromMap(Map<String, dynamic> data) {
    return Record(
      recordID: data['recordID'],
      time: data['time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recordID': recordID,
      'time': time,
    };
  }
}
