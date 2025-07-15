import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project_in_appdev/models/employee.dart';

class EmployeeStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'employees';

  static Future<void> saveEmployees(List<Employee> employees) async {
    final data = Employee.encode(employees);
    await _storage.write(key: _key, value: data);
  }

  static Future<List<Employee>> loadEmployees() async {
    final data = await _storage.read(key: _key);
    if (data == null) return [];
    return Employee.decode(data);
  }

  static Future<void> deleteAll() async {
    await _storage.delete(key: _key);
  }
}
