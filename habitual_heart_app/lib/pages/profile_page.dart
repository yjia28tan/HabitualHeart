import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/pages/user_profile_edit_page.dart';
import '../widgets/profile_button_style.dart';
import '/design/font_style.dart';
import '/widgets/textfield_style.dart';
import '/pages/signin_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/ProfilePage';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _username = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    _currentUser = _auth.currentUser;
    setState(() {});
  }

  // Sign out function
  Future<void> signOut() async {
    await _auth.signOut();
    Navigator.of(context).pushNamed(SigninPage.routeName);
  }

  // Fetch user data from Firestore
  Future fetchUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();
        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          setState(() {
            _username = userData['username'] ?? '';
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, //disable back button
          title: Text(
            "Profile",
            style: headerText,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  // Profile Picture
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hi,',
                        style: signinTitle,
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Username
                  Text(
                    '${_currentUser!.displayName}!',
                    style: userName_display,
                  ),
                  SizedBox(height: 20),
                  // Elevated Buttons
                  // edit profile
                  profile_Button(
                      'Edit Profile',
                      Icons.arrow_forward_ios, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage()),
                    );
                  }),
                  SizedBox(height: 15),
                  // set reminder
                  profile_Button(
                      'Set Reminder',
                      Icons.arrow_forward_ios, () {
                    // TODO: Implement set reminder feature
                  }),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'More',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 15),
                  // set reminder
                  profile_Button(
                      'Privacy Policy',
                      Icons.arrow_forward_ios, () {
                    // TODO: Implement privacy policy feature
                  }),
                  SizedBox(height: 15),
                  profile_Button(
                      'Terms and Conditions',
                      Icons.arrow_forward_ios, () {
                    // TODO: Implement Terms and Conditions feature
                  }),// Add some space between buttons
                  SizedBox(height: 20),
                  Container(
                    height: 45,
                    width: 250,
                    child: signout_Button(
                        'Log Out',
                        Icons.logout, () {
                          signOut();
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              ),
            ),
        ),
    );
  }
}