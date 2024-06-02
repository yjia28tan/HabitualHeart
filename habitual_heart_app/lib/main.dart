import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habitual_heart_app/pages/calendar_page.dart';
import 'package:habitual_heart_app/pages/discover_page.dart';
import 'package:habitual_heart_app/pages/habits_page.dart';
import 'package:habitual_heart_app/pages/profile_page.dart';
import 'package:habitual_heart_app/pages/signin_page.dart';
import 'package:habitual_heart_app/pages/signup_page.dart';
import 'package:habitual_heart_app/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyASN6GATF_FlE2N6oaAF9Hn4uGSEct6jJQ',
      appId: '1:416442513165:android:6a87482795f65140fd6244',
      messagingSenderId: '416442513165',
      projectId: 'habitual-heart',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitual Heart',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE5FFD0),
          selectedItemColor: Color(0xFFFF366021),
          unselectedItemColor: Color(0xFF34A853),
        ),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF366021)),
      ),
      initialRoute: SigninPage.routeName,
      routes: {
        SigninPage.routeName: (context) => const SigninPage(),
        HomePage.routeName: (context) => HomePage(),
        CalendarPage.routeName : (context) => CalendarPage(),
        HabitsPage.routeName : (context) => HabitsPage(),
        DiscoverPage.routeName : (context) => DiscoverPage(),
        ProfilePage.routeName: (context) => ProfilePage(),
      },
    );
  }
}