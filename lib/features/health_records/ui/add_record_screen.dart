import 'package:flutter/material.dart';
import 'package:health_mate/utils/colors.dart';
import 'package:health_mate/utils/custom_button.dart';
import 'package:provider/provider.dart';
import '../data/health_record_model.dart';
import '../provider/health_record_provider.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final stepsCtrl = TextEditingController();
  final caloriesCtrl = TextEditingController();
  final waterCtrl = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: accentColor,
        title: const Text(
          "Add Health Record",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date: ${selectedDate.toString().split(" ")[0]}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    InkWell(
                      onTap: _pickDate,
                      child: const Text(
                        "Pick Date",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: stepsCtrl,
                  label: "Steps Walked",
                  icon: Icons.directions_walk,
                  color: stepColor,
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: caloriesCtrl,
                  label: "Calories Burned",
                  icon: Icons.local_fire_department,
                  color: caloriesColor,
                ),

                const SizedBox(height: 20),

                _inputField(
                  controller: waterCtrl,
                  label: "Water Intake (ml)",
                  icon: Icons.water_drop,
                  color: waterColor,
                ),
                const SizedBox(height: 20),

                CustomButton(
  text: "Save Record",
  onPressed: () => _save(context),
  backgroundColor: accentColor,
  foregroundColor: Colors.white,
  verticalPadding: 14,
  fontSize: 18,
  fontWeight: FontWeight.w600,
  borderRadius: 14,
),

              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _inputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  required Color color,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: color),

      
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),

     
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: lightGray, width: 2),
      ),

      
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: 2),
      ),

      filled: true,
      fillColor: Colors.white60,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
    ),
    validator: (v) => v!.isEmpty ? "Required" : null,
  );
}


  Future _pickDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: selectedDate,
    );

    if (newDate != null) {
      setState(() => selectedDate = newDate);
    }
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<HealthRecordProvider>(
        context,
        listen: false,
      );

      final record = HealthRecord(
        date: selectedDate.toString().split(" ")[0],
        steps: int.parse(stepsCtrl.text),
        calories: int.parse(caloriesCtrl.text),
        water: int.parse(waterCtrl.text),
      );

      provider.addRecord(record);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Record added successfully!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
