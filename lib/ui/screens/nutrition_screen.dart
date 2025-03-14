import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../resources/colors.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final TextEditingController mealController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController waterController = TextEditingController();

  List<Map<String, dynamic>> loggedMeals = [];
  List<int> loggedWaterIntake = [];
  bool _showMealInputs = false;
  bool _showWaterTracker = false;
  int totalWaterIntake = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? mealsString = prefs.getString('loggedMeals');
    final String? waterString = prefs.getString('loggedWaterIntake');

    if (mealsString != null) {
      setState(() {
        loggedMeals = List<Map<String, dynamic>>.from(json.decode(mealsString));
      });
    }

    if (waterString != null) {
      setState(() {
        loggedWaterIntake = List<int>.from(json.decode(waterString));
        totalWaterIntake = loggedWaterIntake.fold(0, (sum, item) => sum + item);
      });
    }
  }

  void _logMeal() {
    if (mealController.text.isEmpty || caloriesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal name and calories are required!')),
      );
      return;
    }

    setState(() {
      loggedMeals.add({
        'meal': mealController.text,
        'calories': double.tryParse(caloriesController.text) ?? 0,
        'protein': double.tryParse(proteinController.text) ?? 0,
        'carbs': double.tryParse(carbsController.text) ?? 0,
        'fats': double.tryParse(fatsController.text) ?? 0,
      });

      mealController.clear();
      caloriesController.clear();
      proteinController.clear();
      carbsController.clear();
      fatsController.clear();
      _showMealInputs = false;
    });

    _saveMeals();
  }

  void _logWaterIntake() {
    if (waterController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the amount of water (ml).')),
      );
      return;
    }

    int waterAmount = int.tryParse(waterController.text) ?? 0;

    setState(() {
      loggedWaterIntake.add(waterAmount);
      totalWaterIntake += waterAmount;
      waterController.clear();
    });

    _saveWaterIntake();
  }

  Future<void> _saveMeals() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedMeals', json.encode(loggedMeals));
  }

  Future<void> _saveWaterIntake() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedWaterIntake', json.encode(loggedWaterIntake));
  }

  void _deleteMeal(int index) {
    setState(() {
      loggedMeals.removeAt(index);
    });
    _saveMeals();
  }

  void _deleteWaterEntry(int index) {
    setState(() {
      totalWaterIntake -= loggedWaterIntake[index];
      loggedWaterIntake.removeAt(index);
    });
    _saveWaterIntake();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Nutrition Tracker', style: TextStyle(color: AppColors.neonGreen)),
        backgroundColor: AppColors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildToggleButton(
              label: _showMealInputs ? 'Hide Meal Input' : 'Enter Your Meal',
              onTap: () => setState(() => _showMealInputs = !_showMealInputs),
            ),
            if (_showMealInputs) _buildMealInputFields(),
            _buildLoggedMealsSection(),
            _buildToggleButton(
              label: _showWaterTracker ? 'Hide Water Tracker' : 'Log Water Intake',
              onTap: () => setState(() => _showWaterTracker = !_showWaterTracker),
            ),
            if (_showWaterTracker) _buildWaterTracker(),
            _buildLoggedWaterIntakeSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealInputFields() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildTextField(mealController, 'Meal Name', TextInputType.text),
          _buildTextField(caloriesController, 'Calories', TextInputType.number),
          _buildTextField(proteinController, 'Protein (g)', TextInputType.number),
          _buildTextField(carbsController, 'Carbs (g)', TextInputType.number),
          _buildTextField(fatsController, 'Fats (g)', TextInputType.number),
          ElevatedButton(
            onPressed: _logMeal,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen),
            child: const Text('Log Meal'),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterTracker() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _buildTextField(waterController, 'Enter Water Intake (ml)', TextInputType.number),
          ElevatedButton(
            onPressed: _logWaterIntake,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.neonGreen),
            child: const Text('Log Water Intake'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Total Water Intake: $totalWaterIntake ml',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({required String label, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonGreen,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  
  Widget _buildLoggedMealsSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Logged Meals',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (loggedMeals.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No meals logged yet',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loggedMeals.length,
              itemBuilder: (context, index) {
                final meal = loggedMeals[index];
                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      meal['meal'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Calories: ${meal['calories']} | P: ${meal['protein']}g | C: ${meal['carbs']}g | F: ${meal['fats']}g',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMeal(index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoggedWaterIntakeSection() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Water Intake History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (loggedWaterIntake.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No water intake logged yet',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: loggedWaterIntake.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey[850],
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      '${loggedWaterIntake[index]} ml',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteWaterEntry(index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}