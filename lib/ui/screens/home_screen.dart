import 'package:flutter/material.dart';
import '/resources/colors.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black, 
      body: Center(
        child: Text(
          "Welcome to Biglang Yummy Body GymBud App!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.neonGreen, 
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
