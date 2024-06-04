import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import '/design/font_style.dart';
import '/widgets/textfield_style.dart';
import '/pages/signin_page.dart';
import '/pages/new_habit_page.dart';

class HabitsPage extends StatefulWidget {
  static String routeName = '/HabitsPage';

  const HabitsPage({Key? key}) : super(key: key);

  @override
  State<HabitsPage> createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //disable back button
          title: Text(
            "Habits",
            style: headerText,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF366021),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (child) => NewHabitPage(),
              ),
            );
          },
        ));
  }
}
