import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_heart_app/widgets/alert_dialog_widget.dart';
import 'package:intl/intl.dart';
import '/pages/calendar_page.dart';
import '/pages/discover_page.dart';
import '/pages/habits_page.dart';
import '/pages/profile_page.dart';
import 'package:habitual_heart_app/main.dart';
import '/design/font_style.dart';
import '/widgets/navigation_bar.dart';
import '/pages/user_profile_edit_page.dart';
import 'mood_details_page.dart';
import 'mood_entry_page.dart';
import 'package:habitual_heart_app/models/habit_model.dart';
import 'package:habitual_heart_app/widgets/habit_card.dart';

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

// Global Variables
String? moodID;
String? todayMood;
String? useruid;
Icon? todayMoodIcon;

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String formattedDate =
      DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  String selectedEmoji = '';
  List<HabitModel> habits = [];
  Map<String, int> yesterdayStreakMap = {};
  Map<String, bool> todayStatusMap = {};

  @override
  void initState() {
    super.initState();
    _fetchTodayMood();
    fetchHabits();
  }

  Future<void> _fetchTodayMood() async {
    try {
      // Fetch today's mood from Firebase
      final today = DateTime.now();

      // Calculate the start and end of the day
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(Duration(days: 1));

      print(FirebaseAuth.instance.currentUser?.uid);

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('moodRecord')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThan: endOfDay)
          .orderBy('timestamp',
              descending: true) // Order by timestamp in descending order
          .limit(1) // Limit to 1 document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        setState(() {
          todayMood = doc['mood'];
          useruid = doc['uid'];
          moodID = doc.id; // Set moodID to the ID of the mood document
          print("Today Mood: $todayMood");
          _updateMoodIcon(todayMood!); // Update the icon based on today's mood
        });
      } else {
        setState(() {
          todayMood = null; // Set todayMood to null
          useruid = null; // Assuming you want to reset useruid as well
          moodID = null; // Reset moodID if no mood record found
        });
        print('No mood record found for today');
      }
    } catch (error) {
      showAlert(context, 'Error', 'Error fetching today\'s mood: $error');
    }
  }

  void _updateMoodIcon(String mood) {
    switch (mood) {
      case 'Excellent':
        todayMoodIcon = Icon(
          Icons.sentiment_very_satisfied,
          size: 90,
        );
        break;
      case 'Good':
        todayMoodIcon = Icon(
          Icons.sentiment_satisfied,
          size: 90,
        );
        break;
      case 'Neutral':
        todayMoodIcon = Icon(
          Icons.sentiment_neutral,
          size: 90,
        );
        break;
      case 'Bad':
        todayMoodIcon = Icon(
          Icons.sentiment_dissatisfied,
          size: 90,
        );
        break;
      case 'Terrible':
        todayMoodIcon = Icon(
          Icons.sentiment_very_dissatisfied,
          size: 90,
        );
        break;
      default:
        todayMoodIcon = null; // Set to null if mood is not recognized
    }
  }

  Future<void> fetchHabits() async {
    try {
      final uid = globalUID;
      List<HabitModel> fetchedHabits = [];
      Map<String, int> fetchedStreaksMap = {};
      Map<String, bool> fetchedStatusMap = {};
      Map<String, dynamic> todayStatusData = {};
      DateTime now = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day);
      DateTime yesterday = now.subtract(const Duration(days: 1));

      QuerySnapshot habitSnapshot = await FirebaseFirestore.instance
          .collection('habits')
          .where('userID', isEqualTo: uid)
          .get();

      for (QueryDocumentSnapshot doc in habitSnapshot.docs) {
        String habitID = doc.id;
        HabitModel habit =
            HabitModel.fromMap(habitID, doc.data() as Map<String, dynamic>);
        fetchedHabits.add(habit);

        QuerySnapshot todayStatusSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .where('date', isEqualTo: Timestamp.fromDate(now))
            .limit(1)
            .get();

        if (todayStatusSnapshot.docs.isNotEmpty) {
          todayStatusData =
              todayStatusSnapshot.docs.first.data() as Map<String, dynamic>;
          fetchedStatusMap[habitID] = todayStatusData['status'];
        } else {
          fetchedStatusMap[habitID] = false;
        }

        QuerySnapshot yesterdayRecordSnapshot = await FirebaseFirestore.instance
            .collection('habitRecord')
            .where('habitID', isEqualTo: habitID)
            .where('date', isLessThan: Timestamp.fromDate(now))
            .orderBy('date', descending: true)
            .limit(1)
            .get();

        if (todayStatusSnapshot.docs.isNotEmpty &&
            (todayStatusData['status'])) {
          fetchedStreaksMap[habitID] = todayStatusData['streak'];
        } else {
          if (yesterdayRecordSnapshot.docs.isNotEmpty) {
            var yesterdayRecordData = yesterdayRecordSnapshot.docs.first.data()
                as Map<String, dynamic>;
            if (yesterdayRecordData['date'] == Timestamp.fromDate(yesterday)) {
              fetchedStreaksMap[habitID] = yesterdayRecordData['streak'];
            } else {
              fetchedStreaksMap[habitID] = 0;
            }
          } else {
            fetchedStreaksMap[habitID] = 0;
          }
        }
      }
      setState(() {
        habits = fetchedHabits;
        yesterdayStreakMap = fetchedStreaksMap;
        todayStatusMap = fetchedStatusMap;
      });
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            formattedDate,
            style: headerText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  if (todayMood != null) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                      child: Text(
                        "Today's Mood",
                        style: homeSubHeaderText,
                      ),
                    ),
                    _buildMoodDisplayContainer(),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0),
                      child: Text(
                        'How are you feeling today?',
                        style: homeSubHeaderText,
                      ),
                    ),
                    MoodRow(
                      onMoodSelected: (mood) {
                        setState(() {
                          selectedEmoji = mood;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      HabitModel habit = habits[index];
                      int yesterdayStreak =
                          yesterdayStreakMap[habit.habitID] ?? 0;
                      bool todayStatus = todayStatusMap[habit.habitID] ?? false;
                      if (!todayStatusMap.containsKey(habit.habitID) ||
                          !todayStatusMap[habit.habitID]!) {
                        return HabitCard(
                          habit: habit,
                          yesterdayStreak: yesterdayStreak,
                          todayStatus: todayStatus,
                          fetchHabits: fetchHabits,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodDisplayContainer() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodDetailsPage(
              moodId: moodID!, // Pass moodID to MoodDetailsPage
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Color(0xFFE5FFD0).withOpacity(0.3),
            border: Border.all(
              color: Color(0xFF366021),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              todayMoodIcon ?? Icon(todayMoodIcon as IconData?),
              Text(
                todayMood!,
                style: userName_display,
              ),
            ],
          ),
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
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 10.0),
      child: Column(
        children: [
          Container(
            height: 120,
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
                  label: 'Excellent',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_satisfied,
                  label: 'Good',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_neutral,
                  label: 'Neutral',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_dissatisfied,
                  label: 'Bad',
                  onSelected: onMoodSelected,
                ),
                MoodIcon(
                  icon: Icons.sentiment_very_dissatisfied,
                  label: 'Terrible',
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
