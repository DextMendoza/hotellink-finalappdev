import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class ViewPayrollScreen extends StatelessWidget {
  final List<PayrollRecord> payrollRecords;

  const ViewPayrollScreen({super.key, required this.payrollRecords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll Report View')),
      body: payrollRecords.isEmpty
          ? const Center(child: Text('No payroll records found.'))
          : ListView.builder(
              itemCount: payrollRecords.length,
              itemBuilder: (context, index) {
                final record = payrollRecords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text('Employee ID: ${record.employeeId}'),
                    subtitle: Text(
                      'Month: ${record.month}\nSalary: ₱${record.salary}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
