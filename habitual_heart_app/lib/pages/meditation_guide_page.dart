import 'package:flutter/material.dart';
import '/models/meditation_tools.dart'; //

class MeditationGuidePage extends StatelessWidget {
  final MeditationTool tool;

  const MeditationGuidePage({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget guideWidget;

    // Determine which guide content to display based on the selected tool
    switch (tool.title) {
      case 'Mindfulness':
        // guideWidget = MindfulnessGuide(); // Use the mindfulness guide widget
        break;
      case 'Breathing Exercise':
        // guideWidget = BreathingExerciseGuide(); // Use the breathing exercise guide widget
        break;
      default:
        guideWidget = Container(); // Default empty widget
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tool.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tool.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // guideWidget, // Display the selected guide content widget
          ],
        ),
      ),
    );
  }
}
