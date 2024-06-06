import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

        return ListTile(
          leading: getMoodIcon(mood) ?? Icon(Icons.sentiment_satisfied),
          title: Text(mood),
          subtitle: Text('$description\n${timestamp.toLocal()}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => onDelete(record.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
