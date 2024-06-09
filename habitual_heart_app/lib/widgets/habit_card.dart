import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/pages/edit_habit_page.dart';
import 'package:habitual_heart_app/pages/habit_check_in_page.dart';

class HabitCard extends StatefulWidget {
  const HabitCard(
      {super.key,
      required this.habit,
      required this.yesterdayStreak,
      required this.todayStatus,
      required this.fetchHabits});

  final HabitModel habit;
  final int yesterdayStreak;
  final bool todayStatus;
  final VoidCallback fetchHabits;

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: IgnorePointer(
        ignoring: widget.todayStatus,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HabitCheckInPage(
                    habit: widget.habit, fetchHabits: widget.fetchHabits),
              ),
            );
          },
          child: Slidable(
            key: Key(widget.habit.habitID),
            actionPane: const SlidableScrollActionPane(),
            secondaryActions: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 63,
                  child: IconSlideAction(
                    caption: 'Edit',
                    color: Colors.lightGreenAccent,
                    icon: Icons.edit,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditHabitPage(habit: widget.habit)),
                      );
                      if (result == true) {
                        widget.fetchHabits();
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 63,
                    child: IconSlideAction(
                      caption: 'Delete',
                      color: Colors.lightGreen,
                      icon: Icons.delete,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this habit?\n\n'
                                'Note: This will also delete all associated habit records.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  deleteHabit(widget.habit);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            child: Card(
              child: ListTile(
                leading: habitCategoryIcon(widget.habit.habitCategory),
                title: Text(widget.habit.habitName),
                subtitle: Text(widget.habit.habitCategory),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: widget.todayStatus ? Colors.orange : Colors.grey,
                    ),
                    Text(widget.yesterdayStreak.toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  void deleteHabit(HabitModel habit) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('habits').doc(habit.habitID).delete();
      QuerySnapshot habitRecordsSnapshot = await firestore
          .collection('habitRecord')
          .where('habitID', isEqualTo: habit.habitID)
          .get();
      for (DocumentSnapshot doc in habitRecordsSnapshot.docs) {
        await doc.reference.delete();
      }
      if (scaffoldMessengerKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldMessengerKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Habit deleted successfully.')),
        );
        widget.fetchHabits();
      }
    } catch (error) {
      if (scaffoldMessengerKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldMessengerKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Failed to delete habit: $error')),
        );
      }
    }
  }
}
