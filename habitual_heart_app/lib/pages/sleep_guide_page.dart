import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../design/font_style.dart';

class SleepingGuideContent extends StatefulWidget {
  @override
  State<SleepingGuideContent> createState() => _SleepingGuideContentState();
}

class _SleepingGuideContentState extends State<SleepingGuideContent> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await _stopSound();
    } else {
      await _playSound();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  Future<void> _playSound() async {
    await audioPlayer.play(AssetSource('audio/90Minutes_sleep_music.mp3'), volume: 1);
  }

  Future<void> _stopSound() async {
    await audioPlayer.stop();
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
                    Text(
                      'Welcome to guided sleep meditation. \n',
                      style: userName_display,
                    ),
                    Text(
                      'Relax and unwind with this guided sleep meditation. ',
                      style: homeSubHeaderText,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'As you lay comfortably in your bed, close your eyes and take a deep breath in. '
                          'Exhale slowly and feel your body begin to relax. '
                          'Imagine a wave of relaxation flowing from the top of your head down to your toes. '
                          'Feel your muscles relax and your mind become calm. '
                          'Focus on the soothing music and let it guide you into a peaceful sleep. '
                          'Continue to breathe deeply and slowly, allowing yourself to drift deeper into relaxation.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Click to play 90 Minutes Peaceful Calm Floating Music for Meditation, Relaxation & Sleep.. ',
              style: TextStyle(
                color: Color(0xFF366021),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: _togglePlayback,
              icon: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                color: homeSubHeaderText.color,
              ),
              label: Text(
                isPlaying ? 'Stop' : 'Play',
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
}
