// lib/screens/add_reminder_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/reminder_service.dart';
import '../services/auth_service.dart';
import '../models/reminder.dart';
import '../widgets/background.dart';
import 'dart:math';

class AddReminderScreen extends StatefulWidget {
  static const routeName = '/add-reminder';

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDateTime;

  bool _isLoading = false;
  String _error = '';

  void _submit() async {
    if (_titleController.text.isEmpty || _selectedDateTime == null) {
      setState(() {
        _error = 'Title and Date/Time are required.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final reminderService =
        Provider.of<ReminderService>(context, listen: false);

    final reminder = Reminder(
      id: Random().nextInt(100000).toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: _selectedDateTime!,
    );

    await reminderService.addReminder(authService.username!, reminder);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }

  Future<void> _pickDateTime() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the default background color
      backgroundColor: Colors.transparent,
      body: Background(
        imagePath: 'assets/images/add_reminder_bg.jpg',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Screen Title
              Text(
                'Add Reminder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40.0),
              // Title Field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  labelText: 'Title *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Description Field
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Date & Time Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDateTime == null
                          ? 'Select Date & Time'
                          : '${_selectedDateTime!.toLocal()}'.split('.')[0],
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDateTime,
                    child: Text('Pick'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              // Error Message
              _error.isNotEmpty
                  ? Text(
                      _error,
                      style: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                    )
                  : Container(),
              SizedBox(height: 20.0),
              // Add Reminder Button
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 15.0),
                        child: Text(
                          'Add Reminder',
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
