import 'package:flutter/material.dart';

class MeditationTool {
  final String title;
  final String description;
  final IconData icon;
  final String guide;

  MeditationTool({
    required this.title,
    required this.description,
    required this.icon,
    required this.guide,
  });
}

// List of tools 
final List<MeditationTool> meditationTools = [
  MeditationTool(
    title: 'Mindfulness',
    description: 'Practice mindfulness meditation',
    icon: Icons.bubble_chart_rounded,
    guide: 'Mindfulness guide content goes here...',
  ),
  MeditationTool(
    title: 'Breathing Exercise',
    description: 'Practice deep breathing exercises',
    icon: Icons.air,
    guide: 'Breathing exercise guide content goes here...',
  ),
  // Add more meditation tools here
];
