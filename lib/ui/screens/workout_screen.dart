import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import '../../resources/colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key, required categoryName});

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int _selectedTab = 0; // 0 = Workouts, 1 = Timer, 2 = History

  // mga categories 
  final List<Map<String, dynamic>> workoutCategories = [
    {'name': 'Strength Training', 'icon': Icons.fitness_center},
    {'name': 'HIIT', 'icon': Icons.flash_on},
    {'name': 'Cardio', 'icon': Icons.directions_run},
  ];

  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>> _workoutHistory = [];

  // timer variables
  int _timerDuration = 30;
  int _remainingTime = 30;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  // timer functions
  void _startTimer() {
    _timer?.cancel();
    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        setState(() => _isRunning = false);
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _timerDuration;
      _isRunning = false;
    });
  }

  void _setTimerDuration(int seconds) {
    setState(() {
      _timerDuration = seconds.clamp(10, 300); // value is between 10-300
      _remainingTime = _timerDuration;
    });
  }

  // save & load workout history
  Future<void> _saveWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('workoutHistory', jsonEncode(_workoutHistory));
  }

  Future<void> _loadWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString('workoutHistory');
    if (historyJson != null) {
      setState(() {
        _workoutHistory = List<Map<String, dynamic>>.from(jsonDecode(historyJson));
      });
    }
  }

  void _logWorkout(String workoutName) {
    final newWorkout = {'name': workoutName, 'date': DateTime.now().toString()};
    setState(() {
      _workoutHistory.insert(0, newWorkout);
    });
    _saveWorkoutHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        title: Text(
          'Workouts',
          style: TextStyle(color: AppColors.neonGreen, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // tab selection
          Row(
            children: [
              Expanded(child: _buildTabButton('Workouts', 0)),
              Expanded(child: _buildTabButton('Workout Timer', 1)),
              Expanded(child: _buildTabButton('Workout History', 2)),
            ],
        ),

          const SizedBox(height: 16),

          // display selected tab content
          Expanded(
            child: _selectedTab == 0
                ? _buildWorkoutsTab()
                : _selectedTab == 1
                    ? _buildWorkoutTimerTab()
                    : _buildWorkoutHistoryTab(),
          ),
        ],
      ),
    );
  }

  // tab button widget
  Widget _buildTabButton(String title, int index) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 3, color: _selectedTab == index ? AppColors.neonGreen : Colors.transparent)),
        ),
        child: Text(
          title,
          style: TextStyle(color: _selectedTab == index ? AppColors.neonGreen : Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // workouts tab
  Widget _buildWorkoutsTab() {
    return Column(
      children: [
        // calendar
        TableCalendar(
          focusedDay: _selectedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.week,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: const TextStyle(color: Colors.white),
            weekendStyle: TextStyle(color: AppColors.neonGreen),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: const TextStyle(color: Colors.white),
            todayDecoration: BoxDecoration(color: const Color.fromARGB(255, 26, 96, 14), shape: BoxShape.circle),
            selectedDecoration: const BoxDecoration(color: Color.fromARGB(255, 86, 86, 86), shape: BoxShape.circle),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) => setState(() => _selectedDay = selectedDay),
        ),
        const SizedBox(height: 16),

        // workout categories
        Expanded(
          child: ListView.builder(
            itemCount: workoutCategories.length,
            itemBuilder: (context, index) {
              final category = workoutCategories[index];
              return Card(
                color: AppColors.neonGreen.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(category['icon'], color: AppColors.neonGreen),
                  title: Text(category['name'], style: const TextStyle(color: Colors.white, fontSize: 18)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onTap: () => _logWorkout(category['name']),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper function to format time into hh:mm:ss
String formatTime(int totalSeconds) {
  final hours = totalSeconds ~/ 3600;
  final minutes = (totalSeconds % 3600) ~/ 60;
  final seconds = totalSeconds % 60;

  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}


Widget _buildWorkoutTimerTab() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Workout Timer',
          style: TextStyle(
              color: AppColors.neonGreen,
              fontSize: 22,
              fontWeight: FontWeight.bold)),
    
      Text(formatTime(_remainingTime),
          style: const TextStyle(
              color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () => _setTimerDuration(_timerDuration - 10)),
          Text('${_timerDuration}s',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _setTimerDuration(_timerDuration + 10)),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(Icons.play_arrow,
                  color: AppColors.neonGreen, size: 36),
              onPressed: _isRunning ? null : _startTimer),
          IconButton(
              icon: const Icon(Icons.pause, color: Colors.white, size: 36),
              onPressed: _isRunning ? _pauseTimer : null),
          IconButton(
              icon: const Icon(Icons.replay,
                  color: Colors.redAccent, size: 36),
              onPressed: _resetTimer),
        ],
      ),
    ],
  );
}


 
  Widget _buildWorkoutHistoryTab() {
    return ListView.builder(
      itemCount: _workoutHistory.length,
      itemBuilder: (context, index) {
        final workout = _workoutHistory[index];
        return Card(
          color: AppColors.neonGreen.withOpacity(0.1),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: AppColors.neonGreen),
            title: Text(workout['name'], style: const TextStyle(color: Colors.white, fontSize: 18)),
            subtitle: Text(workout['date'], style: const TextStyle(color: Colors.white70)),
          ),
        );
      },
    );
  }
}
