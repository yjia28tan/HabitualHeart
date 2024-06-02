import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/main.dart';
import '/design/font_style.dart';
import '/design/font_style.dart';
import '/widgets/textfield_style.dart';
import '/pages/signin_page.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  static String routeName = '/EditProfilePage';

  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _usernameTextController = TextEditingController();

  late String _username = '';
  late String _email = '';
  late String _gender = '';
  late String _selectedGender = '';
  late String _birthdate = '';
  late String _setBirthdate = '';
  late DateTime _selectedDate;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
            _email = userData['email'] ?? '';
            _gender = userData['gender'] ?? '';
            _birthdate = userData['birthdate'] ?? '';
            _selectedGender = _gender;
            _usernameTextController.text = _username;
            _setBirthdate = _birthdate;
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  // Update user data
  Future<void> updateUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        final userQuerySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userDoc = userQuerySnapshot.docs.first;
          final userRef =
          FirebaseFirestore.instance.collection('users').doc(userDoc.id);

          await userRef.update({
            'username': _usernameTextController.text,
            'gender': _selectedGender,
            'birthdate': _setBirthdate,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found.')),
          );
        }
      }
    } catch (error) {
      print('Error updating user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user data')),
      );
    }
  }

  // For date picker
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFFE5FFD0),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF366021),
                  ))),
          child: child!,
        );
      },
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _setBirthdate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white, // set your desired color here
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Profile",
              style: headerText,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        forTextField(
                          "Username",
                          Icons.person,
                          false,
                          _usernameTextController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        forReadTextField(
                          "Email",
                          Icons.email,
                          false,
                          true,
                          _email,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  if (_gender == '')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              const Text('Male'),
                              Radio<String>(
                                value: 'Female',
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedGender = value!;
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          forReadTextField(
                            "Gender",
                            Icons.transgender,
                            false,
                            true,
                            _gender,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birthdate',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        if (_birthdate.isEmpty)
                          InkWell(
                            onTap: () {
                              _selectDate();
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black26,
                                  ),
                                  if (_setBirthdate == '')
                                    Text(
                                      " Select your birthdate",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  else
                                    Text(
                                      " " + _setBirthdate,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        else
                          Container(
                            child: forReadTextField(
                              "Birthdate",
                              Icons.calendar_today,
                              false,
                              true,
                              _birthdate,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: 45,
                    width: 250,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF366021),
                      ),
                      onPressed: () {
                        updateUserData();
                      },
                      icon: const Icon(
                        Icons.system_update_alt,
                          color: Color(0xFFE5FFD0,)
                      ),
                      label: Text(
                        'Update',
                        style: homeButtonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}