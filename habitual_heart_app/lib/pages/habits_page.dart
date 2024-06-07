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
import 'package:habitual_heart_app/data/habit_category_list.dart';

class HabitsPage extends StatefulWidget {
  static String routeName = '/HabitsPage';

  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  List<HabitModel> habits = [];
  late Map<String, HabitRecordModel?> latestRecordsMap;
  String selectedCategory = 'All';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disable back button
        title: Text(
          "Habits",
          style: headerText,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: habitCategoryListItem.map((category) {
                final isSelected = category == selectedCategory;
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: isSelected
                          ? theme.bottomNavigationBarTheme.backgroundColor
                          : theme.bottomNavigationBarTheme.selectedItemColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : theme.bottomNavigationBarTheme
                                  .unselectedItemColor!,
                          width: 1.5,
                        ),
                      ),
                      backgroundColor: isSelected
                          ? theme.bottomNavigationBarTheme.unselectedItemColor
                          : theme.bottomNavigationBarTheme.backgroundColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0)),
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? theme.bottomNavigationBarTheme.backgroundColor : theme.bottomNavigationBarTheme.unselectedItemColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: habits.isNotEmpty
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
          ),
        ],
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
      ),
    );
  }
}
