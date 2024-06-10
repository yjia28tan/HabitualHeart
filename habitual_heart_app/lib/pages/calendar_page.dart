import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:habitual_heart_app/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habitual_heart_app/design/font_style.dart';

class CalendarPage extends StatefulWidget {
  static String routeName = '/CalendarPage';

  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  String? _selectedMood;
  List<Map<String, dynamic>> _completedHabits = [];
  Map<DateTime, String> _moodMap = {};

  @override
  void initState() {
    super.initState();
    _fetchDataForSelectedDay();
    _fetchAllMoods();
  }

  Future<void> _fetchDataForSelectedDay() async {
    final uid = globalUID;
    final startOfDay =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final moodSnapshot = await FirebaseFirestore.instance
        .collection('moodRecord')
        .where('uid', isEqualTo: uid)
        .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timestamp', isLessThan: endOfDay)
        .limit(1)
        .get();

    String? mood;
    if (moodSnapshot.docs.isNotEmpty) {
      mood = moodSnapshot.docs.first['mood'];
    }

    final habitsSnapshot = await FirebaseFirestore.instance
        .collection('habits')
        .where('userID', isEqualTo: uid)
        .get();

    List<String> habitIDs = habitsSnapshot.docs.map((doc) => doc.id).toList();

    final habitRecordSnapshot = await FirebaseFirestore.instance
        .collection('habitRecord')
        .where('habitID', whereIn: habitIDs)
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThan: endOfDay)
        .get();

    List<Map<String, dynamic>> completedHabits = habitRecordSnapshot.docs.map((doc) {
      var data = doc.data();
      var habitDetails = habitsSnapshot.docs.firstWhere((habit) => habit.id == data['habitID']).data();
      return {
        'habitName': habitDetails['habitName'] ?? 'Unnamed Habit',
        'completionTime': data['date'],
        'record': data['record'],
        'status': data['status'],
        'streak': data['streak'],
        'category': habitDetails['habitCategory'],
      };
    }).toList();
    setState(() {
      _selectedMood = mood;
      _completedHabits = completedHabits;
    });
  }

  Future<void> _fetchAllMoods() async {
    final uid = globalUID;

    final moodSnapshot = await FirebaseFirestore.instance
        .collection('moodRecord')
        .where('uid', isEqualTo: uid)
        .get();

    Map<DateTime, String> moodMap = {};
    for (var doc in moodSnapshot.docs) {
      DateTime date = (doc['timestamp'] as Timestamp).toDate();
      moodMap[DateTime(date.year, date.month, date.day)] = doc['mood'];
    }

    setState(() {
      _moodMap = moodMap;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
    _fetchDataForSelectedDay();
  }

  Icon _getMoodIcon(String mood) {
    switch (mood) {
      case 'Excellent':
        return const Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 21,);
      case 'Good':
        return const Icon(Icons.sentiment_satisfied, color: Colors.lightGreen, size: 21,);
      case 'Neutral':
        return const Icon(Icons.sentiment_neutral, color: Colors.amber, size: 21,);
      case 'Bad':
        return const Icon(Icons.sentiment_dissatisfied, color: Colors.orange, size: 21,);
      case 'Terrible':
        return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 21,);
      default:
        return const Icon(Icons.sentiment_neutral, color: Colors.grey, size: 21,);
    }
  }

  Icon _getDefaultIcon() {
    return const Icon(Icons.sentiment_neutral, color: Colors.grey, size: 21,);
  }

  habitCategoryIcon(String category) {
    switch (category) {
      case 'Productivity':
        return const Icon(Icons.auto_graph);
      case 'Financial':
        return const Icon(Icons.attach_money);
      case 'Growth':
        return const Icon(Icons.emoji_events_outlined);
      case 'Health':
        return const Icon(Icons.monitor_heart_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Calendar",
          style: headerText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TableCalendar(
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              firstDay: DateTime.utc(2000, 1, 1),
              lastDay: DateTime.utc(2100, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusDay) {
                  DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                    return Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}',
                          style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          _moodMap.containsKey(normalizedDay)
                              ? _getMoodIcon(_moodMap[normalizedDay]!)
                              : _getDefaultIcon(),
                        ],
                      ),
                    );
                  },
              ),
            ),
            // const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _selectedMood != null ? 'Mood: $_selectedMood' : 'Mood: None',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            // const SizedBox(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: _completedHabits.length,
                itemBuilder: (context, index) {
                  final habit = _completedHabits[index];
                  return Card(
                    child: ListTile(
                      leading: habitCategoryIcon(habit['category']),
                      title: Text(habit['habitName'] ?? 'Unnamed Habit'),
                      subtitle: Text(
                        'Last Record: ${habit['record'] != null && habit['record'].isNotEmpty ? DateFormat('h:mm:ss a').format((habit['record'].last as Timestamp).toDate().toLocal()) : 'No record'}',
                      ),
                      trailing: habit['status'] ?
                      const Text(
                        'Completed',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ) :
                      const Text(
                        'Incomplete',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
