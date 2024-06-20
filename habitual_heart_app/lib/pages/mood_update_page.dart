import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habitual_heart_app/pages/mood_details_page.dart';
import 'package:habitual_heart_app/pages/profile_page.dart';

import '../main.dart';
import '/design/font_style.dart';
import 'home_page.dart';

IconData? selectedMoodIcon;
String? newSelectedMood;

class MoodUpdatePage extends StatefulWidget {
  final String moodId;
  final VoidCallback onUpdateHome;

  const MoodUpdatePage({Key? key, required this.moodId, required this.onUpdateHome}) : super(key: key);

  @override
  _MoodUpdatePageState createState() => _MoodUpdatePageState();
}

class _MoodUpdatePageState extends State<MoodUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  String? _mood;
  String? _description;
  DateTime selectedDateTime = DateTime.now();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMoodDetails();
  }

  Future<void> _fetchMoodDetails() async {
    DocumentSnapshot moodDoc = await FirebaseFirestore.instance.collection('moodRecord').doc(widget.moodId).get();
    if (moodDoc.exists) {
      setState(() {
        _mood = moodDoc['mood'];
        _description = moodDoc['description'];
        selectedDateTime = (moodDoc['timestamp'] as Timestamp).toDate();
        _descriptionController.text = _description ?? '';
        newSelectedMood = _mood;
        _setMoodIcon(_mood);
      });
    }
  }

  void _clearFields() {
    _descriptionController.clear();
    selectedMoodIcon = null;
    newSelectedMood = null;
    selectedDateTime = DateTime.now();
  }

  void _setSelectedMoodIcon(IconData icon, String label) {
    setState(() {
      selectedMoodIcon = icon;
      newSelectedMood = label;
    });
  }

  void _setMoodIcon(String? mood) {
    switch (mood) {
      case 'Excellent':
        selectedMoodIcon = Icons.sentiment_very_satisfied;
        break;
      case 'Good':
        selectedMoodIcon = Icons.sentiment_satisfied;
        break;
      case 'Neutral':
        selectedMoodIcon = Icons.sentiment_neutral;
        break;
      case 'Bad':
        selectedMoodIcon = Icons.sentiment_dissatisfied;
        break;
      case 'Terrible':
        selectedMoodIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        selectedMoodIcon = null; // Set to null if mood is not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MoodDetailsPage(moodId: widget.moodId)
              ),
            ).then((value) => setState(() {})
            );
          },
        ),
        title: Text(
          "Update Mood",
          style: headerText,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showMoodSelectionModalBottomSheet(context);
                  });
                },
                child: Icon(
                  selectedMoodIcon,
                  size: 100,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle date and time selection
                  showDatePicker(
                    context: context,
                    initialDate: selectedDateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
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
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      // User has selected a date
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
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
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          // User has selected both date and time
                          setState(() {
                            selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          });
                        }
                      });
                    }
                  });
                },
                icon: const Icon(Icons.calendar_month, color: Color(0xFF366021)),
                label: Text(
                  '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year} ${selectedDateTime.hour}:${selectedDateTime.minute}',
                  style: homeSubHeaderText,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shadowColor: Colors.transparent,
                ),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Describe your mood:',
                  style: homeSubHeaderText,
                ),
              ),
              SizedBox(height: 6),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Write description...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF366021)),
                  ),
                ),
                maxLines: null,
              ),
              SizedBox(height: 16),
              Container(
                height: 45,
                width: 250,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.update, color: Color(0xFF366021)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5FFD0),
                  ),
                  onPressed: () {
                    // Access the Firestore instance
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    // Get a reference to the document to update
                    DocumentReference moodDocRef = firestore.collection('moodRecord').doc(widget.moodId);

                    // Create a mood record map to update
                    Map<String, dynamic> updatedMoodRecord = {
                      'mood': newSelectedMood,
                      'timestamp': selectedDateTime,
                      'description': _descriptionController.text.trim(),
                    };

                    // Update the mood record in Firestore
                    moodDocRef.update(updatedMoodRecord).then((value) {
                      // Mood record updated successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mood record updated successfully'))
                      );
                      // Trigger home page update
                      widget.onUpdateHome();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage()
                        ),
                      ).then((value) => setState(() {})
                      );
                    }).catchError((error) {
                      // Error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to update mood record: $error'))
                      );
                    });
                  },
                  label: Text('Update', style: homeSubHeaderText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoodSelectionModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 280,
              color: Color(0xFFE5FFD0).withOpacity(0.5),// Set background color
              child: Column(
                children: [
                  _buildMoodOption(Icons.sentiment_very_satisfied, 'Excellent', setState),
                  _buildMoodOption(Icons.sentiment_satisfied, 'Good', setState),
                  _buildMoodOption(Icons.sentiment_neutral, 'Neutral', setState),
                  _buildMoodOption(Icons.sentiment_dissatisfied, 'Bad', setState),
                  _buildMoodOption(Icons.sentiment_very_dissatisfied, 'Terrible', setState),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMoodOption(IconData icon, String label, StateSetter setState) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF366021)),
      title: Text(label, style: TextStyle(color: Color(0xFF366021))),
      onTap: () {
        _setSelectedMoodIcon(icon, label); // Update the parent state
        newSelectedMood = label;
        Navigator.pop(context); // Close the modal bottom sheet
      },
    );
  }
}
