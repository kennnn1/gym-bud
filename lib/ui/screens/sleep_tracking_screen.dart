import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../resources/colors.dart';
import '../../resources/database_helper.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  _SleepTrackerScreenState createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  DateTime? bedtime;
  DateTime? wakeUpTime;
  List<Map<String, dynamic>> sleepHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSleepData();
  }

  Future<void> _loadSleepData() async {
    final dbHelper = DatabaseHelper();
    final history = await dbHelper.getSleepHistory();
    setState(() {
      sleepHistory = history;
    });
  }

  Future<void> _saveSleepData() async {
    if (bedtime != null && wakeUpTime != null) {
      final dbHelper = DatabaseHelper();
      await dbHelper.insertSleepData(
        bedtime!.toIso8601String(),
        wakeUpTime!.toIso8601String(),
      );
      _loadSleepData(); // Reload the history
    }
  }

  void _showDateTimePicker(bool isBedtime) async {
    DateTime initialTime = isBedtime ? bedtime ?? DateTime.now() : wakeUpTime ?? DateTime.now();
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );

    if (pickedTime != null) {
      DateTime selectedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        if (isBedtime) {
          bedtime = selectedTime;
        } else {
          wakeUpTime = selectedTime;
        }
      });

      _saveSleepData();
    }
  }

  Widget _buildSleepHistoryList() {
    return Column(
      children: sleepHistory.map((entry) {
        return ListTile(
          title: Text(
            "Bedtime: ${DateFormat.jm().format(DateTime.parse(entry['bedtime']))}",
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Wake-up: ${DateFormat.jm().format(DateTime.parse(entry['wakeup_time']))}",
            style: TextStyle(color: AppColors.neonGreen),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        title: Text(
          'Sleep Tracker',
          style: TextStyle(color: AppColors.neonGreen, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _showDateTimePicker(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen),
              child: Text(
                bedtime != null ? 'Bedtime: ${DateFormat.jm().format(bedtime!)}' : 'Set Bedtime',
                style: TextStyle(color: AppColors.black, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _showDateTimePicker(false),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen),
              child: Text(
                wakeUpTime != null ? 'Wake-up Time: ${DateFormat.jm().format(wakeUpTime!)}' : 'Set Wake-up Time',
                style: TextStyle(color: AppColors.black, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Sleep History',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildSleepHistoryList(),
          ],
        ),
      ),
    );
  }
}
