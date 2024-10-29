// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/reminder_service.dart';
import 'add_reminder_screen.dart';
import 'login_screen.dart';
import '../widgets/reminder_tile.dart';
import '../widgets/background.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final reminderService =
        Provider.of<ReminderService>(context, listen: false);
    await reminderService.loadReminders(authService.username!);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reminderService = Provider.of<ReminderService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Background(
        imagePath: 'assets/images/home_bg.jpg',
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Title and Logout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Reminders',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      await authService.logout();
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    },
                  )
                ],
              ),
              SizedBox(height: 20.0),
              // Reminders List or Message
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : reminderService.reminders.isEmpty
                      ? Expanded(
                          child: Center(
                            child: Text(
                              'No reminders found. Add some!',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: reminderService.reminders.length,
                            itemBuilder: (context, index) {
                              return ReminderTile(
                                  reminder: reminderService.reminders[index]);
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddReminderScreen.routeName);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
