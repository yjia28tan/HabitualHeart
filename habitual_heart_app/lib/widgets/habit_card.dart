import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/models/habit_record_model.dart';
import 'package:habitual_heart_app/pages/edit_habit_page.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({super.key, required this.habit, this.record});

  final HabitModel habit;
  final HabitRecordModel? record;

  // @override
  // Widget build(BuildContext context) {
  //   return Slidable(
  //     key: Key(habit.habitID),
  //     endActionPane: ActionPane(
  //       motion: const ScrollMotion(),
  //       children: [
  //         SlidableAction(
  //           onPressed: (context) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => EditHabitPage(habit: habit)),
  //             );
  //           },
  //           backgroundColor: Colors.lightGreenAccent,
  //           // foregroundColor: Colors.white,
  //           icon: Icons.edit,
  //           label: 'Edit',
  //         ),
  //         SlidableAction(
  //           onPressed: (context) {
  //             showDialog(
  //               context: context,
  //               builder: (context) => AlertDialog(
  //                 title: const Text('Confirm Delete'),
  //                 content:
  //                     const Text('Are you sure you want to delete this habit?'),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('Cancel'),
  //                   ),
  //                   TextButton(
  //                     onPressed: () {
  //                       deleteHabit(habit);
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Text('Delete'),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //           backgroundColor: Colors.green,
  //           // foregroundColor: Colors.white,
  //           icon: Icons.delete,
  //           label: 'Delete',
  //         ),
  //       ],
  //     ),
  //     child: Card(
  //       child: ListTile(
  //         leading: habitCategoryIcon(habit.habitCategory),
  //         title: Text(habit.habitName),
  //         subtitle: Text(habit.habitCategory),
  //         trailing: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Icon(
  //               Icons.local_fire_department,
  //               color: record != null
  //                   ? record!.streak > 0
  //                       ? Colors.orange
  //                       : Colors.grey
  //                   : Colors.grey,
  //             ),
  //             record != null ? Text(record!.streak.toString()) : const Text('0')
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(habit.habitID),
      actionPane: SlidableScrollActionPane(),
      secondaryActions: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 63,
            child: IconSlideAction(
              caption: 'Edit',
              color: Colors.lightGreenAccent,
              icon: Icons.edit,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditHabitPage(habit: habit)),
                );
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
                          'Are you sure you want to delete this habit?'),
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
          ),
        ),
      ],
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
