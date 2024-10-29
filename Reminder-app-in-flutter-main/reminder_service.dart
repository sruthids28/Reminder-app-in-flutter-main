// lib/services/reminder_service.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class ReminderService with ChangeNotifier {
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  // Load reminders from SharedPreferences
  Future<void> loadReminders(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersString = prefs.getString('reminders_$username');
    if (remindersString != null) {
      _reminders = Reminder.decode(remindersString);
    } else {
      _reminders = [];
    }
    notifyListeners();
  }

  // Save reminders to SharedPreferences
  Future<void> saveReminders(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('reminders_$username', Reminder.encode(_reminders));
  }

  // Add a new reminder
  Future<void> addReminder(String username, Reminder reminder) async {
    _reminders.add(reminder);
    await saveReminders(username);
    notifyListeners();
  }

  // Delete a reminder
  Future<void> deleteReminder(String username, String id) async {
    _reminders.removeWhere((reminder) => reminder.id == id);
    await saveReminders(username);
    notifyListeners();
  }
}
