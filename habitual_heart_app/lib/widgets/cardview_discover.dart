import 'package:flutter/material.dart';

class MeditationToolCard extends StatelessWidget {
  final String backgroundImage;
  final VoidCallback? onTap;

  MeditationToolCard({
    required this.backgroundImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Card(
          color: Colors.transparent, // Make the card transparent
        ),
      ),
    );
  }
}
