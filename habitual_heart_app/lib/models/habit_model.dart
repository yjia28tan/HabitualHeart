class HabitModel {
  String habitID;
  String userID;
  String habitName;
  String habitDescription;
  String habitCategory;
  int habitCount;

  HabitModel({
    required this.habitID,
    required this.userID,
    required this.habitName,
    required this.habitDescription,
    required this.habitCategory,
    required this.habitCount,
  });

  factory HabitModel.fromMap(String habitID, Map<String, dynamic> data) {
    return HabitModel(
      habitID: habitID,
      userID: data['userID'],
      habitName: data['habitName'],
      habitDescription: data['habitDescription'],
      habitCategory: data['habitCategory'],
      habitCount: data['habitCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habitID': habitID,
      'userID': userID,
      'habitName': habitName,
      'habitDescription': habitDescription,
      'habitCategory': habitCategory,
      'habitCount': habitCount,
    };
  }
}
