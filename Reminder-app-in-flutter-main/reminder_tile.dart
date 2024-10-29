// lib/widgets/reminder_tile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reminder.dart';
import '../services/reminder_service.dart';
import '../services/auth_service.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;

  ReminderTile({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final reminderService =
        Provider.of<ReminderService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Card(
      color: Colors.white.withOpacity(0.8),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(
          reminder.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Text(
              reminder.description.isNotEmpty
                  ? reminder.description
                  : 'No Description',
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 4.0),
            Text(
              '${reminder.dateTime.toLocal()}'.split('.')[0],
              style:
                  TextStyle(color: Colors.black54, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            // Confirm deletion
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Delete Reminder'),
                content: Text('Are you sure you want to delete this reminder?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      reminderService.deleteReminder(
                          authService.username!, reminder.id);
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Delete',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
