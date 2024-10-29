// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/reminder_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import '../widgets/background.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _error = '';

  void _register() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.register(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      // Automatically log in the user after registration
      final loginSuccess = await authService.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      if (loginSuccess) {
        // Load reminders after successful login
        final reminderService =
            Provider.of<ReminderService>(context, listen: false);
        await reminderService.loadReminders(authService.username!);
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } else {
      setState(() {
        _error = 'Registration failed. Username already exists.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the default background color
      backgroundColor: Colors.transparent,
      body: Background(
        imagePath: 'assets/images/register_bg.jpg',
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Wrap content vertically
                  children: [
                    // App Title
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.0),
                    // Username Field
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Password Field
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    // Error Message
                    _error.isNotEmpty
                        ? Text(
                            _error,
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            textAlign: TextAlign.center,
                          )
                        : Container(),
                    SizedBox(height: 20.0),
                    // Register Button
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _register,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 15.0),
                              child: Text(
                                'Register',
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
                    SizedBox(height: 10.0),
                    // Navigate to Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
