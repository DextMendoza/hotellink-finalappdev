class PayrollRecord {
  String employeeId;
  double hoursWorked;
  double totalSalary;
  DateTime dateGenerated;

  PayrollRecord({
    required this.employeeId,
    required this.hoursWorked,
    required this.totalSalary,
    required this.dateGenerated,
  });

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'hoursWorked': hoursWorked,
      'totalSalary': totalSalary,
      'dateGenerated': dateGenerated.toIso8601String(),
    };
  }

  factory PayrollRecord.fromJson(Map<String, dynamic> json) {
    return PayrollRecord(
      employeeId: json['employeeId'],
      hoursWorked: (json['hoursWorked'] as num).toDouble(),
      totalSalary: (json['totalSalary'] as num).toDouble(),
      dateGenerated: DateTime.parse(json['dateGenerated']),
    );
  }
}
