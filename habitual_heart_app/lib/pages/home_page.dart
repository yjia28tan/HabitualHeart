import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/pages/calendar_page.dart';
import '/pages/discover_page.dart';
import '/pages/habits_page.dart';
import '/pages/profile_page.dart';
import 'package:habitual_heart_app/main.dart';
import '/design/font_style.dart';
import '/widgets/navigation_bar.dart';
import '/pages/user_profile_edit_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/HomePage';

  const HomePage({Key? key}): super(key: key);

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

//Home
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //disable back button
        title: Center(
          child: Text(
            formattedDate,
            style: headerText,
          ),
        ),
      ),
    );
  }
}