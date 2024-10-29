// lib/models/reminder.dart
import 'dart:convert';

class Reminder {
  String id;
  String title;
  String description;
  DateTime dateTime;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
  });

  // Convert a Reminder into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create a Reminder from a Map
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  // Convert a list of Reminders to JSON
  static String encode(List<Reminder> reminders) => json.encode(
        reminders
            .map<Map<String, dynamic>>((reminder) => reminder.toMap())
            .toList(),
      );

  // Convert JSON to a list of Reminders
  static List<Reminder> decode(String reminders) =>
      (json.decode(reminders) as List<dynamic>)
          .map<Reminder>((item) => Reminder.fromMap(item))
          .toList();
}
