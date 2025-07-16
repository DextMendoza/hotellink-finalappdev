import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class ViewPayrollScreen extends StatefulWidget {
  final List<PayrollRecord> payrollRecords;

  const ViewPayrollScreen({super.key, required this.payrollRecords});

  @override
  State<ViewPayrollScreen> createState() => _ViewPayrollScreenState();
}

class _ViewPayrollScreenState extends State<ViewPayrollScreen> {
  void _editRecord(BuildContext context, int index) {
    final record = widget.payrollRecords[index];
    final TextEditingController employeeIdController = TextEditingController(text: record.employeeId);
    final TextEditingController monthController = TextEditingController(text: record.month);
    final TextEditingController salaryController = TextEditingController(text: record.salary.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Payroll Record'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: employeeIdController,
              decoration: const InputDecoration(labelText: 'Employee ID'),
            ),
            TextField(
              controller: monthController,
              decoration: const InputDecoration(labelText: 'Month (YYYY-MM)'),
            ),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.payrollRecords[index] = PayrollRecord(
                  id: record.id,
                  employeeId: employeeIdController.text,
                  month: monthController.text,
                  salary: double.tryParse(salaryController.text) ?? record.salary,
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteRecord(int index) {
    setState(() {
      widget.payrollRecords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll Report View')),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        child: widget.payrollRecords.isEmpty
            ? const Center(child: Text('No payroll records found.'))
            : ListView.builder(
                itemCount: widget.payrollRecords.length,
                itemBuilder: (context, index) {
                  final record = widget.payrollRecords[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('Employee ID: ${record.employeeId}'),
                      subtitle: Text('Month: ${record.month}\nSalary: ₱${record.salary}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editRecord(context, index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRecord(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
