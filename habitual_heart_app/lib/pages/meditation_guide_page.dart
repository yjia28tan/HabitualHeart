import 'package:flutter/material.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import '../models/meditation_tools.dart';
import 'breathing_page.dart';
import 'mindfulness_page.dart';
import 'sleep_guide_page.dart';

class MeditationGuidePage extends StatelessWidget {
  final MeditationTool tool;

  const MeditationGuidePage({Key? key, required this.tool}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget guideContentWidget;

    // Determine which guide content widget to display based on the selected tool
    switch (tool.title) {
      case 'Mindfulness':
        guideContentWidget = MindfulnessExerciseGuide();
        break;
      case 'Breathing Exercise':
        guideContentWidget = BreathingGuideContent();
        break;
      case 'Sleeping Guide':
        guideContentWidget = SleepingGuideContent(); // Placeholder for future content
        break;
      default:
        guideContentWidget = Container(); // Default empty widget
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, false); // Pass false if no changes
          },
        ),
        title: Text(tool.title,
          style: headerText,
          ),
        ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: guideContentWidget, // Display the selected guide content widget
      ),
    );
  }
}

