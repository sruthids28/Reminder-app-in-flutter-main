// lib/widgets/background.dart
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String imagePath;
  final Widget child;

  Background({required this.imagePath, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Semi-transparent Overlay
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        // Content without SingleChildScrollView
        child,
      ],
    );
  }
}
