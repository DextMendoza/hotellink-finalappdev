import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/screens/payroll_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/xml_helper.dart';

class PayrollReport extends StatefulWidget {
  const PayrollReport({super.key});

  @override
  State<PayrollReport> createState() => _PayrollReportState();
}

class _PayrollReportState extends State<PayrollReport> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _salaryController = TextEditingController();
  DateTime? _selectedMonth;
  List<PayrollRecord> _payrollRecords = [];

  @override
  void dispose() {
    _employeeIdController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickMonth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      helpText: 'Select Payroll Month',
      fieldLabelText: 'Month',
    );
    if (picked != null) {
      setState(() => _selectedMonth = picked);
    }
  }

  void _addPayroll() {
    if (_formKey.currentState!.validate() && _selectedMonth != null) {
      final exists = _payrollRecords.any(
        (record) => record.employeeId == _employeeIdController.text,
      );
      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payroll for this Employee ID already exists!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final payrollRecord = PayrollRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: _employeeIdController.text,
        month: '${_selectedMonth!.year}-${_selectedMonth!.month.toString().padLeft(2, '0')}',
        salary: double.parse(_salaryController.text),
      );
      setState(() {
        _payrollRecords.add(payrollRecord);
        _employeeIdController.clear();
        _salaryController.clear();
        _selectedMonth = null;
      });
    }
  }

  Future<void> _exportToXmlFile() async {
    try {
      final filePath = await XmlHelper.exportPayrollToXml(_payrollRecords);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payroll exported successfully to $filePath!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export payroll: $e')),
      );
    }
  }

  void _clearRecords() {
    setState(() => _payrollRecords.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payroll records cleared for today.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payroll Report')),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter employee ID' : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _pickMonth(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text(
                        _selectedMonth == null
                          ? 'Select Month'
                          : '${_selectedMonth!.year}-${_selectedMonth!.month.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: _salaryController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        contentPadding: EdgeInsets.all(12),
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter salary' : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _addPayroll,
                          child: const Text('Add Payroll'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPayrollScreen(
                                  payrollRecords: _payrollRecords,
                                ),
                              ),
                            );
                          },
                          child: const Text('View Report'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _exportToXmlFile,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text('Export to XML'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _clearRecords,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Clear Today\'s List'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _payrollRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Employee ID: ${_payrollRecords[index].employeeId}'),
                    subtitle: Text('Month: ${_payrollRecords[index].month}, Salary: ₱${_payrollRecords[index].salary}'),
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
