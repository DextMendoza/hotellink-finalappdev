import 'dart:convert';

// Employee Account
class Employee {
  final String id;
  final String employeeId;
  final String name;
  final String email;
  final double salary;

  static var allEmployees;

  // Constructor for  an Employee
  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.salary,
  });

  // Converts the Employee to JSON format
  Map<String, dynamic> toJson() => {
    'id': id,
    'employeeId': employeeId,
    'name': name,
    'email': email,
    'salary': salary,
  };

  // Creates an Employee from JSON format
  static Employee fromJson(Map<String, dynamic> json) => Employee(
    id: json['id'],
    employeeId: json['employeeId'],
    name: json['name'],
    email: json['email'],
    salary: json['salary'],
  );

  // Encodes a list of Employees to JSON string
  static String encode(List<Employee> employees) =>
      jsonEncode(employees.map((e) => e.toJson()).toList());

  // Decodes the JSON string to a list of EMployees
  static List<Employee> decode(String jsonStr) =>
      (jsonDecode(jsonStr) as List<dynamic>)
          .map<Employee>((e) => Employee.fromJson(e))
          .toList();
}
