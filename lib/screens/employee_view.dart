import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/utils/payroll_service.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class EmployeeViewScreen extends StatelessWidget {
  final String employeeId;
  final List<AttendanceRecord> allRecords;

  const EmployeeViewScreen({
    super.key,
    required this.employeeId,
    required this.allRecords,
  });

  @override
  Widget build(BuildContext context) {
    // Compute payroll using PayrollService
    final PayrollRecord payroll = PayrollService.computePayroll(
      employeeId,
      allRecords,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Payroll View'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Employee ID: ${payroll.employeeId}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Hours Worked: ${payroll.hoursWorked.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Salary: ₱${payroll.totalSalary.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date Generated: ${payroll.dateGenerated.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
