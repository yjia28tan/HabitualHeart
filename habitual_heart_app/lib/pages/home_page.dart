import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habitual_heart_app/pages/signin_page.dart';
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

  List screens = [Home()];

  void onClicked(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  //signout function
  signOut() async {
    await auth.signOut();
    Navigator.of(context).pushNamed(SigninPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onClicked: onClicked,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false, //disable back button
        title: Text(
          "Home",
          style: headerText,
        ),
        actions: [
          Row(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 5.0),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).pushNamed(UserProfile.routeName);
              //     },
              //     child: const CircleAvatar(
              //       backgroundImage: AssetImage("assets/profile.png"),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("You are about to log out!"),
                            content: Text(
                                "Are you sure you want to Log Out?"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  signOut();
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: Icon(
                    Icons.logout,
                      color: Color(0xFFFFFFFF,),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: screens.elementAt(selectedIndex),
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
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
    );
  }
}