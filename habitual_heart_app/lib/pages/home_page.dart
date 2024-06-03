import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import '/pages/calendar_page.dart';
import '/pages/discover_page.dart';
import '/pages/habits_page.dart';
import '/pages/profile_page.dart';
import '/pages/set_reminder.dart;
import 'package:habitual_heart_app/main.dart';
import '/design/font_style.dart';
import '/widgets/navigation_bar.dart';
import '/pages/user_profile_edit_page.dart';
import 'mood_entry_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/HomePage';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ProfilePage();
    EditProfilePage();
    _scheduleNotification();
    DiscoverPage();
    print(globalUID);
  }

  List<Widget> screens = [
    Home(),
    CalendarPage(),
    HabitsPage(),
    DiscoverPage(),
    ProfilePage(),
  ];

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
    );
  }
}

class _scheduleNotification {
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  String selectedEmoji = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // disable back button
          title: Text(
            "Home",
            style: headerText,
          ),
        ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                  child: Text(
                    'How are you feeling today?',
                    style: homeSubHeaderText,
                  ),
                ),
                // Emoji selection row
                MoodRow(
                  onMoodSelected: (mood) {
                    setState(() {
                      selectedEmoji = mood;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            // Habits column
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            'Habits',
                            style: homeSubHeaderText,
                          ),
                        ],
                      ),
                    ),

                  ),
                  SizedBox(height: 10.0),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodRow extends StatelessWidget {
  final Function(String) onMoodSelected;

  const MoodRow({Key? key, required this.onMoodSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,12.0,20.0,10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFE5FFD0).withOpacity(0.3), // Background color
              border: Border.all(
                color: Color(0xFF366021), // Border color
                width: 2.0, // Border width
              ),
              borderRadius: BorderRadius.circular(8.0), // Border radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MoodIcon(
                  icon: Icons.sentiment_very_satisfied,
                  label: 'Happy',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_satisfied,
                  label: 'Content',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_neutral,
                  label: 'Neutral',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_dissatisfied,
                  label: 'Sad',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'Angry',
                  onSelected: onMoodSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MoodIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function(String) onSelected;

  const MoodIcon({
    Key? key,
    required this.icon,
    required this.label,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          IconButton(
            icon: Icon(
              icon,
              size: 48,
              color: Color(0xFF366021),
            ),
            onPressed: () {
              // Navigate to MoodEntryPage and pass the selected mood label
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoodEntryPage(selectedMood: label),
                ),
              );
            },
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: moodText,
          ),
        ],
      ),
    );

  }
}
