import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../design/font_style.dart';

class BreathingGuideContent extends StatefulWidget {
  @override
  State<BreathingGuideContent> createState() => _BreathingGuideContentState();
}

class _BreathingGuideContentState extends State<BreathingGuideContent> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void dispose() {
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _speakInstructions() async {
    await flutterTts.speak(
      // Insert the breathing exercise instructions here
      'Three Steps to Deep Breathing\n\n'
          'In order to experience deep breathing,\n first\n you will have to identify\n and experience\n the three types of breathing that comprise it.\n For this exercise\n it is better to lay down on your back if possible.\n Place the right hand\n on top of your navel\n and the left hand\n on top of your chest.\n\n Start by observing the natural flow of your breath for a few cycles.\n\n'
          '\n\nAbdominal breathing.\n\n'
          'With the next inhalation,\n think of intentionally sending the air\n towards the navel\n by letting your abdomen expand and rise freely.\n\n'
          'Feel the right hand rising while the left hand remains almost still on top of the chest.\n\n'
          'Feel the right hand coming down as you exhale while keeping the abdomen relaxed.\n\n'
          'Continue to repeat this for a few minutes without straining the abdomen,\n but rather allowing it to expand and relax freely.\n\n'
          'After some repetitions,\n return to your natural breathing.\n\n'
          '\n\nThoracic breathing.\n\n'
          'Without changing your position,\n you will now shift your attention to your ribcage.\n\n'
          'With the next inhalation,\n think of intentionally sending the air\n towards your rib cage\n instead of the abdomen.\n\n'
          'Let the thorax expand\n and rise freely,\n allowing your left hand\n to move up\n and down\n as you keep breathing.\n\n'
          'Breath through the chest\n without engaging your diaphragm,\n slowly\n and deeply.\n\n'
          'Your right hand\n should remain almost still.\n\n'
          'Continue to repeat this breathing pattern for a few minutes.\n\n'
          'After some repetitions,\n return to your natural breathing.\n\n'
          '\n\nClavicular breathing.\n\n'
          'With the next inhalation,\n repeat the thoracic breathing pattern.\n\n'
          'When the ribcage is completely expanded,\n inhale a bit more thinking\n of allowing the air\n to fill the upper section of your lungs\n at the base of your neck.\n\n'
          'Feel the shoulders\n and collar bone\n rise up gently\n to find some space for the extra air to come in.\n\n'
          'Exhale slowly\n letting the collarbone\n and shoulders\n drop first\n and then\n continue to relax the ribcage.\n\n'
          'Continue to repeat this for a few minutes.\n\n'
          'After some repetitions,\n return to your natural breathing.',
    );
  }

  Future<void> _playSound() async {
    await audioPlayer.play(AssetSource('audio/deepMeditation.mp3'), volume: 1); // Adjust the volume as needed
  }

  Future<void> _stopSound() async {
    await audioPlayer.stop();
  }

  Future<void> _playInstructionsWithMusic() async {
    // Play the background music
    await _playSound();
    // Speak the instructions
    await _speakInstructions();
    // Stop the music after speaking
    await _stopSound();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeading('Three Steps to Deep Breathing'),
                    _buildParagraph(
                      'In order to experience deep breathing, first you will have to identify and experience the three types of breathing that comprise it. '
                          'For this exercise it is better to lay down on your back if possible. '
                          'Place the right hand on top of your navel and the left hand on top of your chest. '
                          'Start by observing the natural flow of your breath for a few cycles.',
                    ),
                    SizedBox(height: 20.0),
                    _buildSubheading('1. Abdominal Breathing'),
                    _buildParagraph(
                      'With the next inhalation, think of intentionally sending the air towards the navel by letting your abdomen expand and rise freely. '
                          'Feel the right hand rising while the left hand remains almost still on top of the chest. '
                          'Feel the right hand coming down as you exhale while keeping the abdomen relaxed. '
                          'Continue to repeat this for a few minutes without straining the abdomen, but rather allowing it to expand and relax freely. '
                          'After some repetitions, return to your natural breathing.',
                    ),
                    SizedBox(height: 12.0),
                    _buildSubheading('2. Thoracic Breathing'),
                    _buildParagraph(
                      'Without changing your position, you will now shift your attention to your ribcage. '
                          'With the next inhalation, think of intentionally sending the air towards your rib cage instead of the abdomen. '
                          'Let the thorax expand and rise freely, allowing your left hand to move up and down as you keep breathing. '
                          'Breathe through the chest without engaging your diaphragm, slowly and deeply. Your right hand should remain almost still. '
                          'Continue to repeat this breathing pattern for a few minutes. After some repetitions, return to your natural breathing.',
                    ),
                    SizedBox(height: 10.0),
                    _buildSubheading('3. Clavicular Breathing'),
                    _buildParagraph(
                      'With the next inhalation, repeat the thoracic breathing pattern. '
                          'When the ribcage is completely expanded, inhale a bit more thinking of allowing the air to fill the upper section of your lungs at the base of your neck.'
                          'Feel the shoulders and collar bone rise up gently to find some space for the extra air to come in. '
                          'Exhale slowly letting the collarbone and shoulders drop first and then continue to relax the ribcage. '
                          'Continue to repeat this for a few minutes. After some repetitions, return to your natural breathing.',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                if (isPlaying) {
                  await flutterTts.stop();
                  await _stopSound();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Playing Instructions...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await _playSound();
                  await _playInstructionsWithMusic();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              icon: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: homeSubHeaderText.color,
              ),
              label: Text(
                isPlaying ? 'Stop Instructions' : 'Play Instructions',
                style: homeSubHeaderText,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE5FFD0), // Background color
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Button padding
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Button shape
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String text) {
    return Column(
      children: [
        Text(
          text,
          style: userName_display,
        ),
        SizedBox(height: 12.0),
      ],
    );
  }

  Widget _buildSubheading(String text) {
    return Text(
      text,
      style: homeSubHeaderText,
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
