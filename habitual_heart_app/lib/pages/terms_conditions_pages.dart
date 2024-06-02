import 'package:flutter/material.dart';

import '../design/font_style.dart';

class TermsAndConditionsPage extends StatelessWidget {
  static String routeName = '/TermsAndConditionsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Terms and Conditions'),
        titleTextStyle: headerText,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
            1. Introduction
            Welcome to our application. By accessing or using our app, you agree to be bound by these terms and conditions.
            
            2. Use of the Application
            You agree to use the application only for lawful purposes and in a way that does not infringe the rights of, restrict, or inhibit anyone else's use and enjoyment of the application.
            
            3. User Accounts
            To use certain features of the application, you may need to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.
            
            4. Privacy Policy
            Your use of the application is also governed by our Privacy Policy.
            
            5. Modifications to the Terms
            We reserve the right to modify these terms at any time. Any changes will be effective immediately upon posting the revised terms.
            
            6. Contact Us
            If you have any questions about these terms, please contact us.
            
            These are just example terms and conditions. You should consult with a legal expert to create comprehensive terms that suit your specific needs.
          ''',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
