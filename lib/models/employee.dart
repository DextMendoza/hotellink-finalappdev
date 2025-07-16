import 'dart:convert';

class Employee {
  final String id;
  final String employeeId;
  final String name;
  final String email;
  final double salary;

  static var allEmployees;

  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.salary,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeId': employeeId,
        'name': name,
        'email': email,
        'salary': salary,
      };

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        employeeId: json['employeeId'],
        name: json['name'],
        email: json['email'],
        salary: json['salary'],
      );

  static String encode(List<Employee> employees) =>
      jsonEncode(employees.map((e) => e.toJson()).toList());

  static List<Employee> decode(String jsonStr) =>
      (jsonDecode(jsonStr) as List<dynamic>)
          .map<Employee>((e) => Employee.fromJson(e))
          .toList();
}
