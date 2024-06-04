import 'package:flutter/material.dart';
import 'package:habitual_heart_app/pages/home_page.dart';

import '../design/font_style.dart';
import 'mood_entry_page.dart';
class MoodDetailsPage extends StatefulWidget {
  final String mood;

  const MoodDetailsPage({Key? key, required this.mood}) : super(key: key);

  @override
  State<MoodDetailsPage> createState() => _MoodDetailsPageState();
}

class _MoodDetailsPageState extends State<MoodDetailsPage> {
  Icon? todayMoodIcon;

  @override
  void initState() {
    super.initState();
    _updateMoodIcon(widget.mood); // Initialize the mood icon
  }

  void _updateMoodIcon(String mood) {
    switch (mood) {
      case 'Happy':
        setState(() {
          todayMoodIcon = Icon(Icons.sentiment_very_satisfied);
        });
        break;
      case 'Content':
        setState(() {
          todayMoodIcon = Icon(Icons.sentiment_satisfied);
        });
        break;
      case 'Neutral':
        setState(() {
          todayMoodIcon = Icon(Icons.sentiment_neutral);
        });
        break;
      case 'Sad':
        setState(() {
          todayMoodIcon = Icon(Icons.sentiment_dissatisfied);
        });
        break;
      case 'Angry':
        setState(() {
          todayMoodIcon = Icon(Icons.sentiment_very_dissatisfied);
        });
        break;
      default:
        setState(() {
          todayMoodIcon = null; // Set to null if mood is not recognized
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String todayMood = widget.mood;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Details', style: headerText),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (todayMoodIcon != null) // Check if mood icon is not null
              Icon(
                todayMoodIcon!.icon,
                size: 100,
                color: Color(0xFF366021),
              ),
            SizedBox(height: 16),
            Text(
              'Mood: $todayMood',
              style: TextStyle(fontSize: 24, color: Color(0xFF366021)),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF366021)),
            ),
            SizedBox(height: 8),
            // Replace with the actual description from Firestore
            Text(
              'Description text from Firestore',
              style: TextStyle(fontSize: 16, color: Color(0xFF366021)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the edit page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoodEntryPage(selectedMood: todayMood)),
                );
              },
              child: Text('Edit', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF366021),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement delete function here
              },
              child: Text('Delete', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF366021),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
