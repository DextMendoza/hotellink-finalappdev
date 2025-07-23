// attendance_storage.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:final_project_in_appdev/models/attendance_record.dart';

class AttendanceStorage {
  static const _key = 'attendance_records';

  /// Save attendance records to local storage
  static Future<void> saveRecords(List<AttendanceRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final recordList = records.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_key, recordList);
  }

  /// Load attendance records from local storage
  static Future<List<AttendanceRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final recordList = prefs.getStringList(_key);
    if (recordList == null) return [];
    return recordList.map((r) => AttendanceRecord.fromJson(jsonDecode(r))).toList();
  }

  /// Add a single record
  static Future<void> addRecord(AttendanceRecord newRecord) async {
    final records = await loadRecords();
    records.add(newRecord);
    await saveRecords(records);
  }

  /// Clear all records (optional)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
