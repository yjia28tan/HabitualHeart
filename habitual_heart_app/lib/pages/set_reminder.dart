import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
        print('Error fetching reminder status: $e');
        // Optionally, you can show a user-friendly error message here
      }
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
      });
      _saveReminderStatus();
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

  void _scheduleNotification() {
    if (_dailyReminder && _reminderTime != null) {
      // Schedule notification logic here
      // This is platform-specific; you can use plugins like flutter_local_notifications for this
    }
  }

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
          _dailyReminder = value;
          if (_dailyReminder) {
            _selectTime();
          } else {
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
