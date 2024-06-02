import 'package:flutter/material.dart';

import '../design/font_style.dart';

// class ProfilePage extends StatefulWidget {
//   static String routeName = '/ProfilePage';
//
//   const PrivacyPolicyPage({Key? key}) : super(key: key);
//
//   @override
//   State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
// }

class PrivacyPolicyPage extends StatefulWidget {
  static String routeName = '/PrivacyPolicyPage';

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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
        title: Text('Privacy Policy'),
        titleTextStyle: headerText,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          '''
          1. Introduction
          This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.
          
          2. Information Collection
          We may collect information about you in a variety of ways. The information we may collect via the application includes:
          - Personal Data
          - Derivative Data
          - Mobile Device Access
          - Push Notifications
          
          3. Use of Your Information
          We may use the information we collect about you in the following ways:
          - To provide, operate, and maintain our application
          - To improve, personalize, and expand our application
          - To understand and analyze how you use our application
          
          4. Disclosure of Your Information
          We may share information we have collected about you in certain situations. Your information may be disclosed as follows:
          - By Law or to Protect Rights
          - Business Transfers
          
          5. Security of Your Information
          We use administrative, technical, and physical security measures to help protect your personal information.
          
          6. Policy for Children
          We do not knowingly solicit information from or market to children under the age of 13.
          
          7. Changes to This Privacy Policy
          We may update this Privacy Policy from time to time. We will notify you of any changes by updating the new Privacy Policy on this page.
          
          8. Contact Us
          If you have any questions about this Privacy Policy, please contact us.
          
          These are just example privacy policy terms. You should consult with a legal expert to create a comprehensive policy that suits your specific needs.
          ''',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
