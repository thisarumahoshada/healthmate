


import 'package:flutter/material.dart';
import 'package:health_mate/utils/colors.dart';
import 'package:health_mate/utils/custom_text_field.dart';
import 'package:health_mate/utils/custom_button.dart';
import 'package:provider/provider.dart';
import '../data/health_record_model.dart';
import '../provider/health_record_provider.dart';

class EditRecordScreen extends StatefulWidget {
  final HealthRecord record;
  const EditRecordScreen({super.key, required this.record});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  late TextEditingController stepsCtrl;
  late TextEditingController caloriesCtrl;
  late TextEditingController waterCtrl;

  @override
  void initState() {
    stepsCtrl = TextEditingController(text: widget.record.steps.toString());
    caloriesCtrl =
        TextEditingController(text: widget.record.calories.toString());
    waterCtrl = TextEditingController(text: widget.record.water.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        iconTheme: const IconThemeData(color: Colors.white), // back arrow white
        title: const Text(
          "Edit Health Record",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Date: ${widget.record.date}", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            // Steps
            CustomTextField(
  controller: stepsCtrl,
  label: "Steps",
  icon: Icons.directions_walk,
  focusedBorderColor: Colors.green,
  keyboardType: TextInputType.number,
),

            const SizedBox(height: 20),

            // Calories
            CustomTextField(
  controller: caloriesCtrl,
  label: "Calories",
  icon: Icons.local_fire_department,
  focusedBorderColor: Colors.red,
  keyboardType: TextInputType.number,
),

            const SizedBox(height: 20),

            // Water
            CustomTextField(
  controller: waterCtrl,
  label: "Water (ml)",
  icon: Icons.water_drop,
  focusedBorderColor: Colors.blue,
  keyboardType: TextInputType.number,
),

            const SizedBox(height: 30),

            CustomButton(
  text: "Save Changes",
  onPressed: () {
    final updated = HealthRecord(
      id: widget.record.id,
      date: widget.record.date,
      steps: int.parse(stepsCtrl.text),
      calories: int.parse(caloriesCtrl.text),
      water: int.parse(waterCtrl.text),
    );

    Provider.of<HealthRecordProvider>(context, listen: false)
        .updateRecord(updated);

    Navigator.pop(context);
  },
),


          ],
        ),
      ),
    );
  }
}
