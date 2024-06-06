import 'package:flutter/material.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/models/habit_record_model.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({Key? key, required this.habit, this.record})
      : super(key: key);

  final HabitModel habit;
  final HabitRecordModel? record;

  @override
  Widget build(BuildContext context) {
    return Card(
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
          )),
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
}
