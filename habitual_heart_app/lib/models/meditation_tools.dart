import 'package:flutter/material.dart';

class MeditationTool {
  final String title;
  final String description;
  final IconData icon;
  final String guide;
  final String backgroundImage; // Add the backgroundImage property

  MeditationTool({
    required this.title,
    required this.description,
    required this.icon,
    required this.guide,
    required this.backgroundImage, // Update the constructor
  });
}

// List of tools
final List<MeditationTool> meditationTools = [
  MeditationTool(
    title: 'Mindfulness',
    description: 'Practice mindfulness meditation',
    icon: Icons.bubble_chart_rounded,
    guide: 'Mindfulness guide content goes here...',
    backgroundImage: 'assets/images/mindfulness.jpg',
  ),
  MeditationTool(
    title: 'Breathing Exercise',
    description: 'Practice deep breathing exercises',
    icon: Icons.air,
    guide: 'Breathing exercise guide content goes here...',
    backgroundImage: 'assets/images/breathing.jpg',
  ),
  MeditationTool(
    title: 'Sleeping Guide',
    description: 'sleep wel',
    icon: Icons.bedtime,
    guide: 'Sleep guide content goes here...',
    backgroundImage: 'assets/images/sleep.jpg',
  ),
  // Add more meditation tools here
];
