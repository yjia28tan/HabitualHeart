# HabitualHeart
6002CEM – Mobile App Development Assignment 

**Members:**

Tan Yi Jia\
Teh Ger Min

Habitual Heart is a moods and habits tracking application that developed with Flutter and Firebase. 
Habitual Heart aims to help users build and maintain healthy moods and habits. 

**Key Features:**

1. Register Account/ Sign in
2. Daily Mood tracking
3. Daily Habits tracking
4. Iterative Calendar View
5. Daily Quotes
6. Meditation Guides
7. Meditation Videos (YouTube API)
8. Daily Reminder
9. Profile Management

**IDE Version:**\
IDE: Android Studio\
Version: Hedgehog | 2023.1.1 Patch 2

**Database:**\
Firebase

**APIs and Third-Party Libraries**
 -  cupertino_icons: ^1.0.6
 - firebase_core: ^3.1.0
 - firebase_auth: ^5.1.0
 - firebase_ui_auth: ^1.14.0
 - firebase_database: ^11.0.1
 - cloud_firestore: ^5.0.1
 - google_fonts: ^6.2.1
 - intl: 0.18.1
 - provider: ^6.1.2
 - http: ^1.2.1
 - url_launcher: ^6.0.10
 - flutter_local_notifications: ^17.1.2
 - timezone: ^0.9.3
 - flutter_slidable: ^0.6.0
 - flutter_tts: ^4.0.2
 - audioplayers: ^6.0.0
 - table_calendar: ^3.0.0

**APIs:**
- YouTube Video API
- Daily Quotes API (Quotable from GitHub)
  - https://github.com/lukePeavey/quotable


**Additional Steps to Run the Program**

To run this program on another computer, follow these steps:
1. Ensure you have Flutter and Dart installed on your system.
2. Install Android Studio and set up the Flutter plugin.
3. Clone the repository or copy the project files to your local machine.
4. Open the project in Android Studio.
5. Update the `android/app/src/main/AndroidManifest.xml` and `android/app/build.gradle` files with the appropriate package names and dependencies.
6. Add your Firebase project configuration in `android/app/google-services.json` file.
7. Run `flutter pub get` to install all dependencies.
8. Connect an Android device or start an Android emulator.
9. Run the app using `flutter run` or through the Run option in Android Studio.
