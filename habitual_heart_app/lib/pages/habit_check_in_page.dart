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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disable back button
        title: Text(
          "Habit Check In",
          style: headerText,
        ),
      ),
    );
  }
}
