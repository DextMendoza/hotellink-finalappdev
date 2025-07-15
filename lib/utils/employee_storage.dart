
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project_in_appdev/models/employee.dart';

class EmployeeStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'employees';

  /// Save a list of employees
  static Future<void> saveEmployees(List<Employee> employees) async {
    try {
      final data = Employee.encode(employees);
      await _storage.write(key: _key, value: data);
    } catch (e) {
      print('Error saving employees: $e');
    }
  }

  /// Load a list of employees
  static Future<List<Employee>> loadEmployees() async {
    try {
      final data = await _storage.read(key: _key);
      if (data == null || data.isEmpty) return [];
      return Employee.decode(data);
    } catch (e) {
      print('Error loading employees: $e');
      return [];
    }
  }

  /// Delete all employee data
  static Future<void> deleteAll() async {
    try {
      await _storage.delete(key: _key);
    } catch (e) {
      print('Error deleting employees: $e');
    }
  }

  /// Add a new employee to storage
  static Future<void> addEmployee(Employee employee) async {
    final employees = await loadEmployees();
    employees.add(employee);
    await saveEmployees(employees);
  }

  /// Update an existing employee by ID
  static Future<void> updateEmployee(Employee updated) async {
    final employees = await loadEmployees();
    final index = employees.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      employees[index] = updated;
      await saveEmployees(employees);
    }
  }

  /// Delete employee by ID
  static Future<void> deleteEmployee(String id) async {
    final employees = await loadEmployees();
    employees.removeWhere((e) => e.id == id);
    await saveEmployees(employees);
  }
}
