import 'package:flutter/material.dart';
import 'package:habitual_heart_app/models/habit_model.dart';

class EditHabitPage extends StatefulWidget{
  final HabitModel habit;

  const EditHabitPage({super.key, required this.habit});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold();
  }
}