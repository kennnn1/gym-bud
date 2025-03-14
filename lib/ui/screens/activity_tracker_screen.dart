import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../resources/colors.dart'; 

class ActivityTrackerScreen extends StatefulWidget {
  const ActivityTrackerScreen({super.key});

  @override
  _ActivityTrackerScreenState createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  final List<int> weeklySteps = [5000, 7000, 8000, 6000, 10000, 12000, 9000]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          "Activity Tracker",
          style: TextStyle(color: AppColors.neonGreen),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(
              "Weekly Steps",
              style: TextStyle(color: AppColors.neonGreen, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}k',
                          style: TextStyle(color: AppColors.neonGreen, fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
                          return Text(
                            days[value.toInt()],
                            style: TextStyle(color: AppColors.neonGreen, fontSize: 12),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(weeklySteps.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklySteps[index] / 1000,
                          color: AppColors.neonGreen,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20),

            
            Text(
              "Calories Burned",
              style: TextStyle(color: AppColors.neonGreen, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "You've burned 1800 kcal this week!",
                style: TextStyle(color: AppColors.neonGreen, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            
            Text(
              "Active Time",
              style: TextStyle(color: AppColors.neonGreen, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Total Active Time: 5 hours 20 mins",
                style: TextStyle(color: AppColors.neonGreen, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),

            
            Text(
              "Workout Summary",
              style: TextStyle(color: AppColors.neonGreen, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🏋️ Strength Training: 3 Sessions", style: TextStyle(color: AppColors.neonGreen, fontSize: 16)),
                  SizedBox(height: 5),
                  Text("🏃 Running: 10km this week", style: TextStyle(color: AppColors.neonGreen, fontSize: 16)),
                  SizedBox(height: 5),
                  Text("🧘 Yoga: 2 Sessions", style: TextStyle(color: AppColors.neonGreen, fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
