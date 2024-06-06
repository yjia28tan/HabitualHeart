import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/main.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/models/habit_record_model.dart';
import 'package:habitual_heart_app/widgets/habit_card.dart';
import '/widgets/textfield_style.dart';
import '/pages/signin_page.dart';
import '/pages/new_habit_page.dart';

class HabitsPage extends StatefulWidget {
  static String routeName = '/HabitsPage';

  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  List<HabitModel> habits = [];
  late Map<String, HabitRecordModel?> latestRecordsMap;
  // late HabitRecordModel latestRecords;

  @override
  void initState() {
    super.initState();
    latestRecordsMap = {};
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    try {
      final uid = globalUID;
      QuerySnapshot habitSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('userID', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in habitSnapshot.docs) {
        String habitID = doc.id;
        HabitModel habit =
            HabitModel.fromMap(habitID, doc.data() as Map<String, dynamic>);
        habits.add(habit);

        // Fetch latest record for the habit (if exists) and store it in the map
        QuerySnapshot recordSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (recordSnapshot.docs.isNotEmpty) {
          String habitRecordID = recordSnapshot.docs.first.id;
          latestRecordsMap[habitID] = HabitRecordModel.fromMap(habitRecordID,
              recordSnapshot.docs.first.data() as Map<String, dynamic>);
        } else {
          latestRecordsMap[habitID] = null;
        }
      }

      setState(() {});
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //disable back button
          title: Text(
            "Habits",
            style: headerText,
          ),
        ),
        body: habits.isNotEmpty
            ? ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return HabitCard(
                    habit: habits[index],
                    record: latestRecordsMap[habits[index].habitID],
                  );
                },
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF366021),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (child) => const NewHabitPage(),
              ),
            );
          },
        ));
  }
}
