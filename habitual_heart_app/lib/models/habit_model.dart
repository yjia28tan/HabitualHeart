class HabitModel {
  String userID;
  String habitsID;
  String? icon;
  String name;
  int checkinTimes;

  HabitModel({
    required this.userID,
    required this.habitsID,
    this.icon,
    required this.name,
    required this.checkinTimes,

  });

  factory HabitModel.fromMap(Map<String, dynamic> data) {
    return HabitModel(
      userID: data['userID'],
      habitsID: data['habitsID'],
      icon: data['icon'],
      name: data['name'],
      checkinTimes: data['checkinTimes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'habitsID': habitsID,
      'icon': icon,
      'name': name,
      'checkinTimes': checkinTimes,
    };
  }
}
