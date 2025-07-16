import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class PayrollReport extends StatefulWidget {
  const PayrollReport({super.key});

  @override
  State<PayrollReport> createState() => _PayrollReportState();
}

class _PayrollReportState extends State<PayrollReport> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _monthController = TextEditingController();
  final _salaryController = TextEditingController();
  List<PayrollRecord> _payrollRecords = [];

  @override
  void dispose() {
    _employeeIdController.dispose();
    _monthController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _addPayroll() {
    if (_formKey.currentState!.validate()) {
      final payrollRecord = PayrollRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: _employeeIdController.text,
        month: _monthController.text,
        salary: double.parse(_salaryController.text),
      );
      setState(() {
        _payrollRecords.add(payrollRecord);
      });
      _employeeIdController.clear();
      _monthController.clear();
      _salaryController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll Report')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _employeeIdController,
                    decoration: const InputDecoration(
                      labelText: 'Employee ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter employee ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _monthController,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter month';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _salaryController,
                    decoration: const InputDecoration(
                      labelText: 'Salary',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter salary';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addPayroll,
                    child: const Text('Add Payroll'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _payrollRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      'Employee ID: ${_payrollRecords[index].employeeId}',
                    ),
                    subtitle: Text(
                      'Month: ${_payrollRecords[index].month}, Salary: ₱${_payrollRecords[index].salary}',
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
