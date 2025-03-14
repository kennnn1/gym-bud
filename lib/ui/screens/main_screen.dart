import 'package:flutter/material.dart';
import '../../resources/colors.dart';
import '../screens/workout_screen.dart';
import '../screens/nutrition_screen.dart';
import '../screens/sleep_tracking_screen.dart';
import '../screens/activity_tracker_screen.dart';
import '../screens/personalization_screen.dart';
import '../screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; 

  final List<Widget> _screens = [
    WorkoutScreen(categoryName: null),
    NutritionScreen(),
    HomeScreen(), 
    SleepTrackerScreen(),
    ActivityTrackerScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black, 
        elevation: 0, 
        title: Text(
          "GymBud",
          style: TextStyle(
            color: AppColors.neonGreen, 
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: AppColors.neonGreen,
            ), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonalizationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: "Workouts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fastfood),
                label: "Nutrition",
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neonGreen, 
                  ),
                  child: Icon(Icons.home, color: Colors.black),
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.nights_stay),
                label: "Sleep",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: "Activity",
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.black,
            selectedItemColor: AppColors.neonGreen,
            unselectedItemColor: Colors.white60,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}