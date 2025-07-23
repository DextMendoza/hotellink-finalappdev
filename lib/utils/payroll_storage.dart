import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class PayrollStorage {
  static const _key = 'payroll_records';
  static const _secureStorage = FlutterSecureStorage();

  /// Save all payroll records
  static Future<void> saveRecords(List<PayrollRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = records.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }

  /// Load records, filtering if current user is employee
  static Future<List<PayrollRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];

    final allRecords = jsonList
        .map((e) => PayrollRecord.fromJson(jsonDecode(e)))
        .toList();

    final role = await _secureStorage.read(key: 'current_user_role');
    final email = await _secureStorage.read(key: 'current_user_email');

    if (role == 'employee') {
      // Only return records for the logged-in employee
      return allRecords.where((r) => r.employeeId == email).toList();
    }

    // Admins get everything
    return allRecords;
  }

  /// Clear all payroll records (used by admin only)
  static Future<void> clearRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
