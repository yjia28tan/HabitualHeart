import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../pages/mood_details_page.dart';

class MoodListWidget extends StatelessWidget {
  final List<DocumentSnapshot> moodRecords;
  final Function(String) onDelete;

  MoodListWidget({
    required this.moodRecords,
    required this.onDelete,
  });

  Icon? getMoodIcon(String mood) {
    switch (mood) {
      case 'Excellent':
        return Icon(Icons.sentiment_very_satisfied);
      case 'Good':
        return Icon(Icons.sentiment_satisfied);
      case 'Neutral':
        return Icon(Icons.sentiment_neutral);
      case 'Bad':
        return Icon(Icons.sentiment_dissatisfied);
      case 'Terrible':
        return Icon(Icons.sentiment_very_dissatisfied);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: moodRecords.length,
      itemBuilder: (context, index) {
        var record = moodRecords[index];
        var mood = record['mood'] ?? 'Unknown';
        var description = record['description'] ?? 'No description';
        var timestamp = (record['timestamp'] as Timestamp).toDate();

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoodDetailsPage(moodId: record.id),
                ),
              );
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Color(0xFFE5FFD0).withOpacity(0.8),
              child: ListTile(
                leading: getMoodIcon(mood) ?? Icon(Icons.sentiment_satisfied),
                title: Text(
                  mood,
                  style: TextStyle(
                    color: Color(0xFF366021),
                  ),
                ),
                subtitle: Text(
                  '$description\n${timestamp.toLocal()}',
                  style: TextStyle(
                    color: Color(0xFF366021),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Color(0xFF366021)),
                  onPressed: () => onDelete(record.id),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
