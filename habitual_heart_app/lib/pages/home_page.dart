import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_heart_app/pages/calendar_page.dart';
import 'package:habitual_heart_app/pages/discover_page.dart';
import 'package:habitual_heart_app/pages/habits_page.dart';
import 'package:habitual_heart_app/pages/profile_page.dart';
import 'package:intl/intl.dart';
import '/pages/signin_page.dart';
import '/design/font_style.dart';
import '/widgets/navigation_bar.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/HomePage';

  const HomePage({Key? key}): super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false, //disable back button
      //   title: Center(
      //     child: Text(
      //       formattedDate,
      //       style: headerText,
      //     ),
      //   ),
      // ),
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