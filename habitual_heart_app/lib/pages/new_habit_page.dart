import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habitual_heart_app/main.dart';
import 'package:habitual_heart_app/design/font_style.dart';
import 'package:habitual_heart_app/data/habit_category_list.dart';

class NewHabitPage extends StatefulWidget {
  const NewHabitPage({super.key});

  @override
  State<NewHabitPage> createState() => _NewHabitPageState();
}

class _NewHabitPageState extends State<NewHabitPage> {
  IconData _selectedIcon = Icons.crop_original;
  String? _selectedCategory;
  int _habitCount = 1;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Productivity':
        return Icons.auto_graph;
      case 'Financial':
        return Icons.attach_money;
      case 'Growth':
        return Icons.emoji_events_outlined;
      case 'Health':
        return Icons.monitor_heart_outlined;
      default:
        return Icons.crop_original;
    }
  }

  Future<void> _submitHabit() async {
    final uid = globalUID;

    if (_nameController.text.isEmpty || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields.')));
      return;
    } else {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference habitCollection = firestore.collection('habits');
      String habitId = habitCollection.doc().id;
      Map<String, dynamic> habitData = {
        'userID': uid,
        'habitName': _nameController.text.trim(),
        'habitDescription': _descriptionController.text.trim(),
        'habitCategory': _selectedCategory,
        'habitCount': _habitCount,
      };
      habitCollection.doc(habitId).set(habitData).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit saved successfully.')));
        _clearFields();
        Navigator.pop(context, true);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save habit: $error')));
      });
    }
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedCategory = null;
      _habitCount = 1;
      _selectedIcon = Icons.add_circle_outline;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categoryItems = habitCategoryListItem
        .where((category) => category != 'All')
        .map((category) => DropdownMenuItem(
              value: category,
              child: Text(category),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "New Habit",
          style: headerText,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              _selectedIcon,
              size: 100.0,
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Habit Name',
                style: homeSubHeaderText,
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: 'Write habit name...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF366021)))),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Habit Description',
                style: homeSubHeaderText,
              ),
            ),
            const SizedBox(height: 6.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Write description...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF366021)))),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Habit Category',
                style: homeSubHeaderText,
              ),
            ),
            const SizedBox(height: 6.0),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: categoryItems,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedIcon = _getIconForCategory(value as String);
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Select category...',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF366021)))),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Habit Daily Count',
                style: homeSubHeaderText,
              ),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_habitCount > 1) {
                        _habitCount--;
                      }
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20.0),
                Text(
                  '$_habitCount',
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(width: 20.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _habitCount++;
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 45,
              width: 250,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.check_circle_rounded,
                  color: theme.bottomNavigationBarTheme.selectedItemColor,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      theme.bottomNavigationBarTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                label: Text(
                  'Submit',
                  style: homeSubHeaderText,
                ),
                onPressed: _submitHabit,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
