class AttendanceRecord {
  final String id;
  final String employeeId;
  final String date;
  final String status;

  AttendanceRecord({
    required this.id,
    required this.employeeId,
    required this.date,
    required this.status,
  });

  // Convert AttendanceRecord to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'date': date,
      'status': status,
    };
  }

  // Create AttendanceRecord from JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      employeeId: json['employeeId'],
      date: json['date'],
      status: json['status'],
    );
  }
}
