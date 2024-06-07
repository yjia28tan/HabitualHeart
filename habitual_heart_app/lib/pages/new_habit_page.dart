import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({super.key});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disable back button
        title: Text(
          "New Habit",
          style: headerText,
        ),
      ),
    );
  }
}
