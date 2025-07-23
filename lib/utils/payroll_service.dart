import 'package:intl/intl.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class PayrollService {
  static const double hourlyRate = 150.0; // Customize as needed

  static final DateFormat _timeFormat = DateFormat('hh:mm a'); // e.g. "08:00 AM"

  /// Computes payroll for a given employee based on their attendance records
  static PayrollRecord? computePayroll(String employeeId, List<AttendanceRecord> records) {
    final List<AttendanceRecord> filtered = records.where((r) =>
      r.employeeId == employeeId &&
      r.status == 'Present' &&
      r.timeIn.isNotEmpty &&
      r.timeOut.isNotEmpty
    ).toList();

    if (filtered.isEmpty) return null;

    double totalHours = 0;

    for (var record in filtered) {
      final hours = _calculateHoursWorked(record.timeIn, record.timeOut);
      totalHours += hours;
    }

    double salary = totalHours * hourlyRate;

    return PayrollRecord(
      employeeId: employeeId,
      hoursWorked: totalHours,
      totalSalary: salary,
      dateGenerated: DateTime.now(),
    );
  }

  /// Parses time strings and calculates total hours worked
  static double _calculateHoursWorked(String timeInStr, String timeOutStr) {
    try {
      final inTime = _timeFormat.parse(timeInStr);
      final outTime = _timeFormat.parse(timeOutStr);

      // Reconstruct full DateTime (today's date with timeIn/timeOut)
      final now = DateTime.now();
      final inDateTime = DateTime(now.year, now.month, now.day, inTime.hour, inTime.minute);
      final outDateTime = DateTime(now.year, now.month, now.day, outTime.hour, outTime.minute);

      final diff = outDateTime.difference(inDateTime).inMinutes;

      return diff > 0 ? diff / 60.0 : 0.0;
    } catch (e) {
      print('Error parsing time: $e');
      return 0.0;
    }
  }
}
