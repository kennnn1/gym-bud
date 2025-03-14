import 'package:flutter/material.dart';
import '../../resources/colors.dart'; // Import the color definitions

class PersonalizationScreen extends StatefulWidget {
  const PersonalizationScreen({super.key});

  @override
  _PersonalizationScreenState createState() => _PersonalizationScreenState();
}

class _PersonalizationScreenState extends State<PersonalizationScreen> {
  String? selectedGoal;
  String? selectedWorkoutType;
  String? selectedDiet;
  bool workoutReminders = false;

  final Map<String, String> goalDescriptions = {
    'Weight Loss': 'Focuses on burning calories and reducing body fat.',
    'Muscle Gain': 'Designed to build muscle mass through resistance training.',
    'Endurance': 'Improves stamina and cardiovascular health with sustained activity.',
  };

  final Map<String, String> workoutDescriptions = {
    'Strength Training': 'Uses resistance to build muscle strength and size.',
    'HIIT': 'High-Intensity Interval Training involves short bursts of intense exercise.',
    'Cardio': 'Improves heart health and burns calories through aerobic activities.',
  };

  final Map<String, String> dietDescriptions = {
    'Vegan': 'Plant-based diet that excludes all animal products.',
    'Keto': 'Low-carb, high-fat diet designed for fat burning and energy.',
    'Gluten-Free': 'Excludes gluten-containing grains like wheat and barley.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true, 
        backgroundColor: AppColors.black,
        title: Text(
          'Personalization',
          style: TextStyle(
            color: AppColors.neonGreen,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownWithInfo(
              title: 'Select Your Fitness Goal',
              value: selectedGoal,
              items: goalDescriptions.keys.toList(),
              descriptions: goalDescriptions,
              onChanged: (value) => setState(() => selectedGoal = value),
            ),
            _buildDropdownWithInfo(
              title: 'Preferred Workout Type',
              value: selectedWorkoutType,
              items: workoutDescriptions.keys.toList(),
              descriptions: workoutDescriptions,
              onChanged: (value) => setState(() => selectedWorkoutType = value),
            ),
            _buildDropdownWithInfo(
              title: 'Dietary Preference',
              value: selectedDiet,
              items: dietDescriptions.keys.toList(),
              descriptions: dietDescriptions,
              onChanged: (value) => setState(() => selectedDiet = value),
            ),
            _buildSwitch(
              title: 'Enable Workout Reminders',
              value: workoutReminders,
              onChanged: (value) => setState(() => workoutReminders = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownWithInfo({
    required String title,
    required String? value,
    required List<String> items,
    required Map<String, String> descriptions,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.neonGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (value != null) 
                IconButton(
                  icon: Icon(Icons.info_outline, color: AppColors.neonGreen),
                  onPressed: () {
                    _showInfoDialog(value, descriptions[value]!);
                                    },
                ),
            ],
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.black,
            value: value,
            onChanged: (newValue) {
              setState(() => onChanged(newValue));
            },
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.neonGreen.withOpacity(0.1),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.neonGreen,
          fontSize: 18,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.neonGreen,
    );
  }

  void _showInfoDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.black,
        title: Text(
          title,
          style: TextStyle(color: AppColors.neonGreen, fontWeight: FontWeight.bold),
        ),
        content: Text(
          description,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Text('Close', style: TextStyle(color: AppColors.neonGreen)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
