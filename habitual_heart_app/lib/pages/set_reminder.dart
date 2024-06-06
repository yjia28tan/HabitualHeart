import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import '../widgets/alert_dialog_widget.dart';

class SetReminder extends StatefulWidget {
  @override
  _SetReminderState createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  bool _dailyReminder = false;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    fetchReminderStatus();
    // _scheduleNotification();
  }

  void fetchReminderStatus() async {
    final uid = globalUID;
    if (uid != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        if (userData.exists) {
          setState(() {
            _dailyReminder = userData.get('dailyReminder') ?? false;
            String? reminderTimeString = userData.get('reminderTime');
            if (reminderTimeString != null && reminderTimeString.contains(':')) {
              final parts = reminderTimeString.split(':');
              final hour = int.tryParse(parts[0]);
              final minute = int.tryParse(parts[1]);
              if (hour != null && minute != null) {
                _reminderTime = TimeOfDay(hour: hour, minute: minute);
              }
            }
          });
        }
      } catch (e) {
        showAlert(context, 'Error', 'Error fetching reminder status: $e');
      }
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(0xFF366021),
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
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
        _dailyReminder = true;  // Ensure the switch remains on
      });
      _saveReminderStatus();
    } else {
      setState(() {
        _dailyReminder = false; // Revert the switch if the time picker is canceled
      });
    }
  }


  void _saveReminderStatus() async {
    final uid = globalUID;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'dailyReminder': _dailyReminder,
        'reminderTime': _reminderTime?.format(context) ?? '',
      });
    }
  }

  // void _scheduleNotification() async {
  //   if (_dailyReminder && _reminderTime != null) {
  //     final now = tz.TZDateTime.now(tz.local);
  //     final scheduledDate = tz.TZDateTime(
  //       tz.local,
  //       now.year,
  //       now.month,
  //       now.day,
  //       _reminderTime!.hour,
  //       _reminderTime!.minute,
  //     );
  //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     AndroidNotificationDetails(
  //       'daily_reminder_channel',
  //       'Daily Reminder',
  //       channelDescription: 'Daily reminder notifications',
  //       importance: Importance.max,
  //       priority: Priority.high,
  //     );
  //
  //     const NotificationDetails platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //     );
  //
  //     await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'Daily Reminder',
  //       'This is your daily reminder!',
  //       _nextInstanceOfTime(scheduledDate),
  //       platformChannelSpecifics,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time,
  //     );
  //   }
  // }
  //
  // tz.TZDateTime _nextInstanceOfTime(tz.TZDateTime scheduledDate) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
  //
  // void _cancelNotification() async {
  //   await flutterLocalNotificationsPlugin.cancel(0);
  // }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Set Reminder',
        style: TextStyle(
          color: Color(0xFF366021),
          fontSize: 16,
        ),
      ),
      secondary: Icon(
        Icons.notifications,
        color: Color(0xFF366021),
      ),
      value: _dailyReminder,
      onChanged: (bool value) {
        setState(() {
          if (value) {
            _selectTime();
          } else {
            _dailyReminder = false;
            _reminderTime = null;
            _saveReminderStatus();
          }
        });
      },
      activeColor: Color(0xFF366021),
      activeTrackColor: Color(0xFFE5FFD0).withOpacity(0.7),
      inactiveThumbColor: Color(0xFFE5FFD0).withOpacity(0.7),
      inactiveTrackColor: Colors.blueGrey[700],
    );
  }



}
