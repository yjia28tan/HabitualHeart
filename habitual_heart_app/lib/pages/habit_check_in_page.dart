import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/pages/habits_page.dart';

class HabitCheckInPage extends StatefulWidget {
  final HabitModel habit;

  const HabitCheckInPage({super.key, required this.habit});

  @override
  State<HabitCheckInPage> createState() => _HabitCheckInPageState();
}

class _HabitCheckInPageState extends State<HabitCheckInPage> {
  DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late int currentCount;
  bool isLoading = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    fetchCurrentCount();
  }

  void fetchCurrentCount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String habitID = widget.habit.habitID;
    try {
      QuerySnapshot habitRecordSnapshot = await firestore
          .collection('habitRecord')
          .where('habitID', isEqualTo: habitID)
          .where('date', isEqualTo: Timestamp.fromDate(now))
          .get();
      setState(() {
        currentCount = habitRecordSnapshot.docs.isNotEmpty
            ? habitRecordSnapshot.docs.first['record'].length
            : 0;
      });
    } catch (e) {
      print('Error fetching current count: $e');
    }
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

  Future<void> submitHabitRecord() async {
    DocumentReference habitRecordRef;
    List<dynamic> records = [];
    late int streak;

    setState(() {
      isLoading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String habitID = widget.habit.habitID;
    try {
      QuerySnapshot habitRecordSnapshot = await firestore
          .collection('habitRecord')
          .where('habitID', isEqualTo: habitID)
          .where('date', isEqualTo: Timestamp.fromDate(now))
          .get();
      if (habitRecordSnapshot.docs.isNotEmpty) {
        habitRecordRef = habitRecordSnapshot.docs.first.reference;
        var data =
            habitRecordSnapshot.docs.first.data() as Map<String, dynamic>;
        records = data['record'] ?? [];
      } else {
        habitRecordRef = firestore.collection('habitRecord').doc();
      }

      records.add(Timestamp.now());
      currentCount = records.length;
      bool status = currentCount == widget.habit.habitCount;

      if (status) {
        DateTime yesterday = now.subtract(const Duration(days: 1));
        QuerySnapshot yesterdaySnapshot = await firestore
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .where('date', isEqualTo: Timestamp.fromDate(yesterday))
            .get();
        if (yesterdaySnapshot.docs.isNotEmpty &&
            yesterdaySnapshot.docs.first['status'] == true) {
          streak = yesterdaySnapshot.docs.first['streak'] + 1;
        } else {
          streak = 1;
        }
      } else if (habitRecordSnapshot.docs.isNotEmpty) {
        streak = habitRecordSnapshot
            .docs.first['streak'];
      }
      await habitRecordRef.set({
        'date': Timestamp.fromDate(now),
        'habitID': habitID,
        'record': records,
        'status': status,
        'streak': status ? streak : 0,
      });
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Habit record submitted successfully')),
      );
      Navigator.pushReplacement(
        scaffoldMessengerKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const HabitsPage(),
        ),
      );
    } catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Failed to submit habit record: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      habitCategoryIcon(widget.habit.habitCategory,
                          size: 100.0),
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
                              labelStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor:
                                  const Color(0xFFE5FFD0).withOpacity(0.7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$currentCount/${widget.habit.habitCount}',
                        style: headerText.copyWith(
                            color: Colors.black, fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 45,
                        width: 250,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.check_circle_rounded,
                            color: theme
                                .bottomNavigationBarTheme.selectedItemColor,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                theme.bottomNavigationBarTheme.backgroundColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          label: Text('Submit', style: homeSubHeaderText),
                          onPressed: submitHabitRecord,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
