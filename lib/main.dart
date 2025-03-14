import 'package:flutter/material.dart';
import 'ui/screens/welcome_screen.dart'; 

void main() {
  runApp(GymBudApp());
}

class GymBudApp extends StatelessWidget {
  const GymBudApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'GymBud',
      theme: ThemeData(
        fontFamily: 'Arial', 
      ),
      home: WelcomeScreen(), 
    );
  }
}
