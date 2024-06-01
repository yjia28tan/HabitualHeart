import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/design/font_style.dart';
import '/pages/signin_page.dart';
import '/widgets/textfield_style.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmTextController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool passwordConfirmed() {
    if (_passwordTextController.text.trim() ==
        _confirmTextController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future addDetails(String uid, String username, String email) async {
    await FirebaseFirestore.instance.collection('users').add({
      'uid': uid,
      'username': username,
      'email': email,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 100, // Adjust the logo size
                          ),
                        ),
                      ),
                      Container(
                        height: 80,
                        child: Center(
                          child: Text(
                            'Habitual Heart',
                            style: signinTitle,
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: signupTitle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      Container(
                        child: forTextField("Username", Icons.person, false,
                            _usernameTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField(
                            "Email", Icons.email, false, _emailTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField("Password", Icons.lock, true,
                            _passwordTextController),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: forTextField("Confirm Password", Icons.lock,
                            true, _confirmTextController),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      //Sign Up Button
                      Container(
                        height: 45,
                        width: 250,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE5FFD0)),
                          onPressed: () async {
                            String username = _usernameTextController.text;
                            String email = _emailTextController.text;
                            String password = _passwordTextController.text;

                            if (email.isEmpty ||
                                password.isEmpty ||
                                username.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Registration Failed'),
                                  content:
                                  const Text('Please fill in all details.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return; // Stop further execution
                            } else if (!passwordConfirmed()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Ensure your password'),
                                  content: const Text(
                                      'Please make sure the password and confirm password are the same.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            //register new user with email and password
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                                .then((userCredential) async {
                              // Extract user ID
                              String uid = userCredential.user!.uid;

                              // Send email verification
                              await userCredential.user!.sendEmailVerification();

                              // Add user details to Firestore
                              addDetails(uid, _usernameTextController.text,
                                  _emailTextController.text);

                              //To notify the user account have created
                              final snackbar = SnackBar(
                                content: Text(
                                    "Account Created! Check Email to verify your account before Sign in. \nWelcome $username"),
                                action: SnackBarAction(
                                    label: 'OK', onPressed: () {}),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);

                              // Navigate to the sign-in page
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SigninPage()));
                            }).catchError((error) {
                              //Error occurred when register
                              String errorMessage = '';

                              if (error is FirebaseAuthException) {
                                if (error.code == 'email-already-in-use') {
                                  // Email is already registered
                                  errorMessage =
                                  'Email is already registered. Please use a different email.';
                                } else if (error.code == 'weak-password') {
                                  // Weak Password entered
                                  errorMessage =
                                  'Password is too weak. Please use a different password.';
                                } else if (error.code == 'invalid-email') {
                                  // Invalid email entered
                                  errorMessage = 'Please use a valid email.';
                                } else {
                                  // Other FirebaseAuthException errors
                                  errorMessage =
                                  'An Error Occurred\nError: ${error.code.toString()}';
                                }
                              } else {
                                // Other errors
                                errorMessage = error.code.toString();
                              }

                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title:
                                    const Text("Registration Failed"),
                                    content: Text(errorMessage),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ));
                            });
                          },
                          icon: const Icon(Icons.check_circle,
                              color: Color(0xFF366021,)
                          ),
                          label: Text(
                            'Sign Up',
                            style: signinText
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            SigninPage.routeName,
                          );
                        },
                        child: const Text(
                          "Already have an account? Click here.",
                          style: TextStyle(
                            color: Color(0xFF366021),
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}