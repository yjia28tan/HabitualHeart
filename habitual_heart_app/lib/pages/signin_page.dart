import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/design/font_style.dart';
import 'package:habitual_heart_app/widgets/textfield_style.dart';
import '/pages/signup_page.dart';
import '/pages/home_page.dart';

class SigninPage extends StatefulWidget {
  static String routeName = '/LoginPage';

  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController _emailTextController = TextEditingController(text: "yijia_tan@hotmail.com");
  TextEditingController _passwordTextController = TextEditingController(text: "123123");

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
                  child:
                  Column(
                    children: [
                      Container(
                        height: 100, // Adjust the height as needed
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 100, // Adjust the logo size as needed
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Center(
                          child: Text(
                            'Habitual Heart',
                            style: signinTitle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),

                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
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
                        height: 80,
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Container(
                      height: 45,
                      width: 250,
                      child:
                      //Login Button
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE5FFD0)),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Center(
                                    child: CircularProgressIndicator());
                              });

                          try {
                            // Sign in with email and password
                            final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text,
                            );

                            // Check if the email is verified
                            if (userCredential.user!.emailVerified) {
                              // Navigate to the home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(),
                                ),
                              );
                            } else {
                              // Email is not verified
                              final snackbar = SnackBar(
                                content: Text("Please verify your email before logging in."),
                                action: SnackBarAction(
                                  label: 'OK',
                                  onPressed: () {},
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackbar);
                            }
                          } catch (error) {
                            // Handle sign-in errors
                            final snackbar = SnackBar(
                              content: Text("Invalid Email or Password."),
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {},
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }
                        },
                        icon: Icon(Icons.login,
                            color: Color(0xFF366021,)
                        ),
                        label: Text(
                          'Sign In',
                          style: homeSubHeaderText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 45,
                      width: 250,
                      child:
                      //Sign Up Button
                      ElevatedButton.icon(
                        icon: Icon(Icons.app_registration,
                            color: Color(0xFF366021,)
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE5FFD0)),
                        onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                        label: Text(
                          'Sign Up',
                          style: homeSubHeaderText,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),

                InkWell(
                  onTap: () async {
                    // Show a progress indicator
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Center(
                          child: CircularProgressIndicator(),
                      );
                    },
                  );

                  try {
                    // Send password reset email
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _emailTextController.text,
                    );

                    // Hide the progress indicator
                    Navigator.pop(context);

                    // Show a success message
                    final snackbar = SnackBar(
                      content: Text("Password reset email sent. Please check your email."),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                  catch (error) {
                    // Hide the progress indicator
                    Navigator.pop(context);

                    // Show an error message
                    final snackbar = SnackBar(
                      content: Text("Failed to send password reset email."),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  child: const Text(
                    "Forgot Password?",
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

        ),
      ],
    );
  }
}