import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class ViewPayrollScreen extends StatefulWidget {
  final List<PayrollRecord> payrollRecords;
  final bool isEmployee;

  const ViewPayrollScreen({
    super.key,
    required this.payrollRecords,
    required this.isEmployee,
  });

  @override
  State<ViewPayrollScreen> createState() => _ViewPayrollScreenState();
}

class _ViewPayrollScreenState extends State<ViewPayrollScreen> {
  String _searchQuery = '';

  void _editRecord(BuildContext context, int index) {
    if (widget.isEmployee) return; // Extra safety check

    final record = widget.payrollRecords[index];

    final employeeIdController = TextEditingController(text: record.employeeId);
    final hoursWorkedController = TextEditingController(
      text: record.hoursWorked.toString(),
    );
    final totalSalaryController = TextEditingController(
      text: record.totalSalary.toString(),
    );

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
              controller: hoursWorkedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Hours Worked'),
            ),
            TextField(
              controller: totalSalaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Total Salary'),
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
                  employeeId: employeeIdController.text,
                  hoursWorked:
                      double.tryParse(hoursWorkedController.text) ??
                      record.hoursWorked,
                  totalSalary:
                      double.tryParse(totalSalaryController.text) ??
                      record.totalSalary,
                  dateGenerated: record.dateGenerated,
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
    if (widget.isEmployee) return; // Extra safety check

    setState(() {
      widget.payrollRecords.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter records by employee ID
    final filteredRecords = _searchQuery.isEmpty
        ? widget.payrollRecords
        : widget.payrollRecords
              .where(
                (r) => r.employeeId.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Report View'),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Employee ID',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredRecords.isEmpty
                  ? const Center(child: Text('No payroll records found.'))
                  : ListView.builder(
                      itemCount: filteredRecords.length,
                      itemBuilder: (context, index) {
                        final record = filteredRecords[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              'Employee ID: ${record.employeeId}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              'Hours Worked: ${record.hoursWorked.toStringAsFixed(2)}\n'
                              'Total Salary: ₱${record.totalSalary.toStringAsFixed(2)}\n'
                              'Date: ${record.dateGenerated.toLocal().toString().split(' ')[0]}',
                            ),
                            trailing: widget.isEmployee
                                ? null
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () =>
                                            _editRecord(context, index),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () => _deleteRecord(index),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
