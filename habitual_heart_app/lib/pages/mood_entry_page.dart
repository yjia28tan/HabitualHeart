import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '/design/font_style.dart';
import 'home_page.dart';

IconData? selectedMoodIcon;
String? newSelectedMood;

class MoodEntryPage extends StatefulWidget {
  final String selectedMood;

  const MoodEntryPage({Key? key, required this.selectedMood}) : super(key: key);

  @override
  _MoodEntryPageState createState() => _MoodEntryPageState();
}

class _MoodEntryPageState extends State<MoodEntryPage> {
  DateTime selectedDateTime = DateTime.now();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Update selectedMoodIcon based on the selected mood
    switch (widget.selectedMood) {
      case 'Happy':
        selectedMoodIcon = Icons.sentiment_very_satisfied;
        break;
      case 'Content':
        selectedMoodIcon = Icons.sentiment_satisfied;
        break;
      case 'Neutral':
        selectedMoodIcon = Icons.sentiment_neutral;
        break;
      case 'Sad':
        selectedMoodIcon = Icons.sentiment_dissatisfied;
        break;
      case 'Angry':
        selectedMoodIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        selectedMoodIcon = null; // Set to null if mood is not recognized
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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Mood Entry",
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
                    print(newSelectedMood);
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
                  // Show date and time picker dialog
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
                  icon: Icon(Icons.add_reaction, color: Color(0xFF366021)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5FFD0),
                  ),
                  onPressed: () {
                    // Access the Firestore instance
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    // Get a reference to the "moodRecord" collection
                    CollectionReference moodRecordCollection = firestore.collection('moodRecord');

                    // Generate a new document ID for the mood record
                    String moodId = moodRecordCollection.doc().id;

                    // Create a new mood record map
                    Map<String, dynamic> moodRecord = {
                      'uid': globalUID, // Assuming you have globalUID defined somewhere
                      'moodid': moodId,
                      'mood': newSelectedMood == null ? widget.selectedMood : newSelectedMood, // Assuming selectedMood is passed to the widget
                      'timestamp': selectedDateTime,
                      'description': _descriptionController.text.trim(), // Assuming _descriptionController is a TextEditingController for the description TextField
                    };

                    // Add the mood record to Firestore
                    moodRecordCollection.doc(moodId).set(moodRecord)
                        .then((value) {
                      // Mood record saved successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mood record saved successfully'))
                      );
                    }).catchError((error) {
                      // Error handling
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save mood record: $error'))
                      );
                    });
                    // Clear fields
                    _clearFields();
                    // Navigate to home page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomePage()), // Assuming HomePage is the home page widget
                    );

                  },
                  label: Text('Create', style: homeSubHeaderText),
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
              height: 250,
              color: Color(0xFFE5FFD0).withOpacity(0.5),// Set background color
              child: Column(
                children: [
                  _buildMoodOption(Icons.sentiment_very_satisfied, 'Happy', setState),
                  _buildMoodOption(Icons.sentiment_satisfied, 'Content', setState),
                  _buildMoodOption(Icons.sentiment_neutral, 'Neutral', setState),
                  _buildMoodOption(Icons.sentiment_dissatisfied, 'Sad', setState),
                  _buildMoodOption(Icons.sentiment_very_dissatisfied, 'Angry', setState),
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
        // selectedMood = null;
        _setSelectedMoodIcon(icon, label); // Update the parent state
        newSelectedMood = label;
        print(newSelectedMood);
        Navigator.pop(context); // Close the modal bottom sheet
      },
    );
  }
}