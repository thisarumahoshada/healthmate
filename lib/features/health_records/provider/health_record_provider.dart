import 'package:flutter/material.dart';
import '../data/health_record_db.dart';
import '../data/health_record_model.dart';

class HealthRecordProvider extends ChangeNotifier {
  List<HealthRecord> records = [];
  bool isLoading = true;

  Future loadRecords() async {
    isLoading = true;
    notifyListeners();

    records = await HealthRecordDB.instance.fetchAllRecords();

    isLoading = false;
    notifyListeners();
  }

  Future addRecord(HealthRecord record) async {
    await HealthRecordDB.instance.insertRecord(record);
    await loadRecords();
  }

  Future updateRecord(HealthRecord record) async {
    await HealthRecordDB.instance.updateRecord(record);
    await loadRecords();
  }

  Future deleteRecord(int id) async {
    await HealthRecordDB.instance.deleteRecord(id);
    await loadRecords();
  }

  List<HealthRecord> filterByDate(String date) {
    return records.where((r) => r.date.contains(date)).toList();
  }

  int todayWater() {
    final today = DateTime.now().toString().split(' ')[0];
    final todayRecords = filterByDate(today);

    return todayRecords.fold(0, (sum, r) => sum + r.water);
  }

  int todaySteps() {
    final today = DateTime.now().toString().split(' ')[0];
    final todayRecords = filterByDate(today);
    return todayRecords.fold(0, (sum, r) => sum + r.steps);
  }
}
