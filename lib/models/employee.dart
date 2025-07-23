import 'dart:convert';

class Employee {
  final String employeeId;
  final String name;
  final String email;
  final String position;

  Employee({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeId: json['employeeId'],
        name: json['name'],
        email: json['email'],
        position: json['position'],
      );

  Map<String, dynamic> toJson() => {
        'employeeId': employeeId,
        'name': name,
        'email': email,
        'position': position,
      };

  // Encoding list of employees to JSON string
  static String encode(List<Employee> employees) => jsonEncode(
        employees.map<Map<String, dynamic>>((e) => e.toJson()).toList(),
      );

  // Decoding JSON string back to list of employees
  static List<Employee> decode(String employees) =>
      (jsonDecode(employees) as List<dynamic>)
          .map<Employee>((e) => Employee.fromJson(e))
          .toList();
}
