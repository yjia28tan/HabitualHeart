import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitual_heart_app/pages/mood_update_page.dart';
import 'package:habitual_heart_app/pages/profile_page.dart';
import 'package:intl/intl.dart';

import '../design/font_style.dart';
import '../widgets/mood_list_widget.dart';

class MoodHistoryPage extends StatefulWidget {
  const MoodHistoryPage({Key? key}) : super(key: key);

  @override
  State<MoodHistoryPage> createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  bool isLoading = true;
  List<DocumentSnapshot> moodRecords = [];

  @override
  void initState() {
    super.initState();
    fetchAllMood();
  }

  void refreshHomePage() {
    setState(() {
      // Refresh your data here
    });
  }

  Future<void> fetchAllMood() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('moodRecord')
          .orderBy('timestamp', descending: true)
          .get();

      setState(() {
        moodRecords = querySnapshot.docs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching moods: $e'),
        ),
      );
    }
  }

  Future<void> deleteMood(String moodId) async {
    try {
      await FirebaseFirestore.instance
          .collection('moodRecord')
          .doc(moodId)
          .delete();
      setState(() {
        moodRecords.removeWhere((record) => record.id == moodId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting mood: $e'),
        ),
      );
    }
  }

  void showDeleteConfirmationDialog(String moodId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this mood record?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
                deleteMood(moodId);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void navigateToUpdatePage(String moodId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoodUpdatePage(
          moodId: moodId,
          onUpdateHome: refreshHomePage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Mood History',
          style: headerText,
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: MoodListWidget(
                moodRecords: moodRecords,
                onDelete: (moodId) => showDeleteConfirmationDialog(moodId),
              ),
            ),
          ),
    );
  }
}
