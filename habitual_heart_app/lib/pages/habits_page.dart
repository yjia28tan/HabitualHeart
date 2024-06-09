import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/main.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/widgets/habit_card.dart';
import '/pages/new_habit_page.dart';
import 'package:habitual_heart_app/data/habit_category_list.dart';

class HabitsPage extends StatefulWidget {
  static String routeName = '/HabitsPage';

  const HabitsPage({super.key});

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  late DateTime now;
  late DateTime yesterday;
  List<HabitModel> habits = [];
  Map<String, int> yesterdayStreakMap = {};
  Map<String, bool> todayStatusMap = {};
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    yesterday = now.subtract(const Duration(days: 1));
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    try {
      final uid = globalUID;
      List<HabitModel> fetchedHabits = [];
      Map<String, int> fetchedStreaksMap = {};
      Map<String, bool> fetchedStatusMap = {};
      Map<String, dynamic> todayStatusData = {};

      QuerySnapshot habitSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('userID', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in habitSnapshot.docs) {
        String habitID = doc.id;
        HabitModel habit =
            HabitModel.fromMap(habitID, doc.data() as Map<String, dynamic>);
        fetchedHabits.add(habit);

        QuerySnapshot todayStatusSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .where('date', isEqualTo: Timestamp.fromDate(now))
            .limit(1)
            .get();

        if (todayStatusSnapshot.docs.isNotEmpty) {
          todayStatusData =
              todayStatusSnapshot.docs.first.data() as Map<String, dynamic>;
          fetchedStatusMap[habitID] = todayStatusData['status'];
        } else {
          fetchedStatusMap[habitID] = false;
        }

        QuerySnapshot yesterdayRecordSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .where('date', isLessThan: Timestamp.fromDate(now))
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (todayStatusData['status'] == true) {
          fetchedStreaksMap[habitID] = todayStatusData['streak'];
        } else {
          if (yesterdayRecordSnapshot.docs.isNotEmpty) {
            var yesterdayRecordData = yesterdayRecordSnapshot.docs.first.data()
                as Map<String, dynamic>;
            if (yesterdayRecordData['date'] == Timestamp.fromDate(yesterday)) {
              fetchedStreaksMap[habitID] = yesterdayRecordData['streak'];
            } else {
              fetchedStreaksMap[habitID] = 0;
            }
          } else {
            fetchedStreaksMap[habitID] = 0;
          }
        }
      }
      setState(() {
        habits = fetchedHabits;
        yesterdayStreakMap = fetchedStreaksMap;
        todayStatusMap = fetchedStatusMap;
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
                        yesterdayStreak:
                            yesterdayStreakMap[filteredHabits[index].habitID] ??
                                0,
                        todayStatus:
                            todayStatusMap[filteredHabits[index].habitID] ??
                                false,
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
