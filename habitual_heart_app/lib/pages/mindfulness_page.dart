import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../design/font_style.dart';

class MindfulnessGuideContent extends StatefulWidget {
  @override
  State<MindfulnessGuideContent> createState() => _MindfulnessGuideContentState();
}

class _MindfulnessGuideContentState extends State<MindfulnessGuideContent> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  String currentAudio = '';

  Future<void> _togglePlayback(String audioPath) async {
    print('Before toggling: isPlaying=$isPlaying, currentAudio=$currentAudio');
    if (isPlaying && currentAudio == audioPath) {
      await _stopSound();
    } else {
      await _playSound(audioPath);
    }
    setState(() {
      isPlaying = !isPlaying;
      currentAudio = isPlaying ? audioPath : '';
      print('After toggling: isPlaying=$isPlaying, currentAudio=$currentAudio');
    });
  }

  Future<void> _playSound(String audioPath) async {
    await audioPlayer.play(AssetSource(audioPath), volume: 1);
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
                      'Welcome to mindfulness meditation. \n',
                      style: userName_display,
                    ),
                    Text(
                      'Mindfulness meditation is a mental training practice that teaches you to slow down racing thoughts, '
                          'let go of negativity, and calm both your mind and body. \n',
                      style: homeSubHeaderText,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Here are some guided mindfulness meditation sessions to help you get started: \n',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    _buildMeditationSection(
                      title: 'Meditation: Reconnecting to Silence and Presence by Tara Brach (19 mins)',
                      audioPath: 'audio/Meditation.mp3',
                    ),
                    _buildMeditationSection(
                      title: 'Mindfulness Meditation on the Breath by Dr. Roberto Benzo (20 mins)',
                      audioPath: 'audio/mindfulness-meditation-on-breath.mp3',
                    ),
                    _buildMeditationSection(
                      title: '90 Minutes of Peaceful Calm Floating Music for Meditation, Relaxation & Sleep by Relax Unwind Meditate',
                      audioPath: 'audio/90Minutes_sleep_music.mp3',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationSection({required String title, required String audioPath}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF366021),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          ElevatedButton.icon(
            onPressed: () => _togglePlayback(audioPath),
            icon: Icon(
              isPlaying && currentAudio == audioPath ? Icons.stop : Icons.play_arrow,
              color: Color(0xFF366021),
            ),
            label: Text(
              isPlaying && currentAudio == audioPath ? 'Stop' : 'Play',
              style: homeSubHeaderText.copyWith(color: Color(0xFF366021),),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE5FFD0),
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
        ],
      ),
    );
  }
}
