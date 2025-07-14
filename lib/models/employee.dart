class Employee {
  String id;
  String employeeId;
  String name;
  String email;
  double salary;

  static List<Employee> allEmployees = [];

  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.salary,
  });
}
