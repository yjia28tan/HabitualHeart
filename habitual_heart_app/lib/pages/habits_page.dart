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
      List<HabitModel> fetchedHabits = [];
      Map<String, HabitRecordModel?> fetchedLatestRecordsMap = {};

      QuerySnapshot habitSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('userID', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in habitSnapshot.docs) {
        String habitID = doc.id;
        HabitModel habit =
            HabitModel.fromMap(habitID, doc.data() as Map<String, dynamic>);
        fetchedHabits.add(habit);

        QuerySnapshot recordSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (recordSnapshot.docs.isNotEmpty) {
          String habitRecordID = recordSnapshot.docs.first.id;
          fetchedLatestRecordsMap[habitID] = HabitRecordModel.fromMap(
              habitRecordID,
              recordSnapshot.docs.first.data() as Map<String, dynamic>);
        } else {
          fetchedLatestRecordsMap[habitID] = null;
        }
      }
      setState(() {
        habits = fetchedHabits;
        latestRecordsMap = fetchedLatestRecordsMap;
      });
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  List<HabitModel> filterHabitsByCategory(String category) {
    if (category == "All") {
      return habits;
    } else {
      return habits.where((habit) => habit.habitCategory == category).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                      color: isSelected
                          ? theme.bottomNavigationBarTheme.backgroundColor
                          : theme.bottomNavigationBarTheme.unselectedItemColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filterHabitsByCategory(selectedCategory).isNotEmpty
                ? ListView.builder(
                    itemCount: filterHabitsByCategory(selectedCategory).length,
                    itemBuilder: (context, index) {
                      final filteredHabits =
                          filterHabitsByCategory(selectedCategory);
                      return HabitCard(
                        habit: filteredHabits[index],
                        record: latestRecordsMap[filteredHabits[index].habitID],
                        fetchHabits: fetchHabits,
                      );
                    },
                  )
                : const Center(
                    child: Text('No Record Found'),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.bottomNavigationBarTheme.selectedItemColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (child) => const NewHabitPage(),
            ),
          );
          if (result == true) {
            fetchHabits();
          }
        },
      ),
    );
  }
}
