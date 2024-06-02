import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/main.dart';
import '/design/font_style.dart';
import '/design/font_style.dart';
import '/pages/user_profile_edit_page.dart';
import '/pages/signin_page.dart';
import '/pages/privacy_policy_page.dart';
import '/pages/terms_conditions_pages.dart';
import '/widgets/textfield_style.dart';
import '/widgets/profile_button_style.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/ProfilePage';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? email;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Sign out function
  Future<void> signOut() async {
    await _auth.signOut();
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
          });
        }).catchError((error) {
          print('Error fetching user data: $error');
        });
      } else {
        print('globalUID is null');
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
                    '$username!',
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
                  // 'More' text
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                    );
                  }),
                  SizedBox(height: 15),
                  profile_Button(
                      'Terms and Conditions',
                      Icons.arrow_forward_ios, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                    );
                  }),
                  SizedBox(height: 20),
                  // sign out button
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