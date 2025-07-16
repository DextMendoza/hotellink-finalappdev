class PayrollRecord {
  String id;
  String employeeId;
  String month;
  double salary;

  PayrollRecord({
    required this.id,
    required this.employeeId,
    required this.month,
    required this.salary,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'month': month,
      'salary': salary,
    };
  }

  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      id: json['id'],
      employeeId: json['employeeId'],
      month: json['month'],
      salary: (json['salary'] as num).toDouble(),
    );
  }
}
