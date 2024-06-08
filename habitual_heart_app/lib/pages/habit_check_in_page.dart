import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/models/habit_model.dart';

class HabitCheckInPage extends StatefulWidget {
  final HabitModel habit;

  const HabitCheckInPage({super.key, required this.habit});

  @override
  State<HabitCheckInPage> createState() => _HabitCheckInPageState();
}

class _HabitCheckInPageState extends State<HabitCheckInPage> {
  int currentCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(
          'Habit Check In',
          style: headerText,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              habitCategoryIcon(widget.habit.habitCategory, size: 100.0),
              const SizedBox(height: 20),
              Text(
                widget.habit.habitName,
                style: headerText.copyWith(color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: 50,
                  maxHeight: 500,
                ),
                child: SingleChildScrollView(
                  child: TextField(
                    controller: TextEditingController(
                      text: widget.habit.habitDescription,
                    ),
                    readOnly: true,
                    maxLines: null,
                    minLines: 1,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                    decoration: InputDecoration(
                      labelStyle:
                          TextStyle(color: Colors.white.withOpacity(0.9)),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: const Color(0xFFE5FFD0).withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 40),
                    onPressed: () {
                      setState(() {
                        if (currentCount > 0) {
                          currentCount--;
                        }
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '$currentCount/${widget.habit.habitCount}',
                      style: headerText.copyWith(
                          color: Colors.black, fontSize: 24),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 40),
                    onPressed: () {
                      setState(() {
                        if (currentCount < widget.habit.habitCount) {
                          currentCount++;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ElevatedButton.icon(
                  icon: Icon(
                    Icons.check_circle_rounded,
                    color: theme.bottomNavigationBarTheme.selectedItemColor,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        theme.bottomNavigationBarTheme.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  label: Text('Submit', style: homeSubHeaderText),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  habitCategoryIcon(String category, {double size = 24.0}) {
    switch (category) {
      case 'Productivity':
        return Icon(Icons.auto_graph, size: size);
      case 'Financial':
        return Icon(Icons.attach_money, size: size);
      case 'Growth':
        return Icon(Icons.emoji_events_outlined, size: size);
      case 'Health':
        return Icon(Icons.monitor_heart_outlined, size: size);
    }
  }
}
