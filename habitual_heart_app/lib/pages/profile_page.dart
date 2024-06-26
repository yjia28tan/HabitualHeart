import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/pages/set_reminder.dart';
import '../widgets/alert_dialog_widget.dart';
import '/main.dart';
import '/design/font_style.dart';
import '/pages/user_profile_edit_page.dart';
import '/pages/signin_page.dart';
import '/pages/privacy_policy_page.dart';
import '/pages/terms_conditions_pages.dart';
import '/widgets/profile_button_style.dart';
import 'mood_history_page.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/ProfilePage';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;
  bool? dailyReminder;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Sign out function
  Future<void> signOut() async {
    await _auth.signOut();
    globalUID = null;
    Navigator.of(context).pushNamed(SigninPage.routeName);
  }

  // Fetch user data from Firestore
  void fetchUserData() {
    final uid = globalUID;
    if (uid != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get().then((userData) {
        setState(() {
          username = userData['username'];
          email = userData['email'];
          dailyReminder = userData['dailyReminder'];
        });
      }).catchError((error) {
        showAlert(context, 'Error', 'Error fetching user data: $error');
      });
    } else {
      showAlert(context, 'Error', 'globalUID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // disable back button
        title: Text(
          "Profile",
          style: headerText,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              // Profile Picture
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hi,',
                    style: signinTitle,
                  ),
                ),
              ),
              // Username
              Text(
                '$username!',
                style: userName_display,
              ),
              SizedBox(height: 20),
              // set reminder button
              SetReminder(),
              SizedBox(height: 15),
              // Elevated Buttons
              // edit profile
              profile_Button(
                'Edit Profile',
                Icons.arrow_forward_ios,
                    () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                  if (result == true) {
                    // Refresh the user data
                    fetchUserData();
                  }
                },
              ),
              SizedBox(height: 15),
              // Elevated Buttons
              // edit profile
              profile_Button(
                'Mood History',
                Icons.arrow_forward_ios,
                    () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoodHistoryPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              // 'More' text
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'More',
                    style: homepageText,
                  ),
                ),
              ),
              SizedBox(height: 15),
              // privacy policy
              profile_Button(
                'Privacy Policy',
                Icons.arrow_forward_ios,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                  );
                },
              ),
              SizedBox(height: 15),
              // t&c
              profile_Button(
                'Terms and Conditions',
                Icons.arrow_forward_ios,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              // sign out button
              Container(
                height: 45,
                width: 250,
                child: signout_Button(
                  'Sign Out',
                  Icons.logout,
                      () {
                    signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
