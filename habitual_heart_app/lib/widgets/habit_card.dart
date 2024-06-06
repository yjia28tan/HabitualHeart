import 'package:flutter/material.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/models/habit_record_model.dart';
import 'package:habitual_heart_app/pages/edit_habit_page.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.habit, this.record});

  final HabitModel habit;
  final HabitRecordModel? record;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(habit.habitID),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.limeAccent,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditHabitPage(habit: habit)),
                  );
                },
              ),
            ),
            Container(
              color: Colors.lime,
              child: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this habbit?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            deleteHabit(habit);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        return false;
      },
      onDismissed: (direction) {},
      child: Card(
        child: ListTile(
          leading: habitCategoryIcon(habit.habitCategory),
          title: Text(habit.habitName),
          subtitle: Text(habit.habitCategory),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: record != null
                    ? record!.streak > 0
                        ? Colors.orange
                        : Colors.grey
                    : Colors.grey,
              ),
              record != null ? Text(record!.streak.toString()) : const Text('0')
            ],
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

  deleteHabit(HabitModel habit) {}
}
