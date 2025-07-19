// Model class representing a payroll record for an employee.
class PayrollRecord {
  String id;
  String employeeId;
  String month;
  double salary;

  // Constructor for creating a PayrollRecord instance.
  PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.salary,
  });

  // Converts the PayrollRecord object to a JSON-compatible map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'month': month,
      'salary': salary,
    };
  }

  // Factory constructor to create a PayrollRecord from a JSON map.
  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      id: json['id'],
      employeeId: json['employeeId'],
      month: json['month'],
      salary: (json['salary'] as num).toDouble(),
    );
  }
}
