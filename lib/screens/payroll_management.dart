import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/screens/payroll_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/xml_helper.dart';
import 'package:final_project_in_appdev/utils/attendance_storage.dart';
import 'package:final_project_in_appdev/utils/payroll_storage.dart';
import 'package:final_project_in_appdev/utils/payroll_service.dart';

class PayrollReport extends StatefulWidget {
  const PayrollReport({super.key});

  @override
  State<PayrollReport> createState() => _PayrollReportState();
}

class _PayrollReportState extends State<PayrollReport> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  List<PayrollRecord> _payrollRecords = [];
  List<AttendanceRecord> _attendanceRecords = [];

  String? _role;
  String? _userEmail;
  String? _userEmployeeId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _role = await _secureStorage.read(key: 'current_user_role');
    _userEmail = await _secureStorage.read(key: 'current_user_email');
    _userEmployeeId = await _secureStorage.read(key: 'current_user_id');

    await _loadAttendanceRecords();
    await _loadPayrollRecords();

    if (_role == 'employee' && _userEmployeeId != null) {
      _generatePayrollForEmployee(_userEmployeeId!);
    }
  }

  Future<void> _loadAttendanceRecords() async {
    final records = await AttendanceStorage.loadRecords();
    setState(() => _attendanceRecords = records);
  }

  Future<void> _loadPayrollRecords() async {
    final records = await PayrollStorage.loadRecords();
    setState(() => _payrollRecords = records);
  }

  void _generatePayrollForEmployee(String empId) {
    if (_payrollRecords.any((r) => r.employeeId == empId)) return;

    final payroll = PayrollService.computePayroll(empId, _attendanceRecords);
    if (payroll != null) {
      setState(() => _payrollRecords.add(payroll));
      PayrollStorage.saveRecords(_payrollRecords);
    }
  }

  void _generatePayrollForAllEmployees() {
    final employeeIds = _attendanceRecords.map((e) => e.employeeId).toSet();

    for (var empId in employeeIds) {
      if (_payrollRecords.any((r) => r.employeeId == empId)) continue;

      final payroll = PayrollService.computePayroll(empId, _attendanceRecords);
      if (payroll != null) {
        _payrollRecords.add(payroll);
      }
    }

    setState(() {});
    PayrollStorage.saveRecords(_payrollRecords);
  }

  void _addPayroll() async {
    if (!_formKey.currentState!.validate()) return;

    final empId = _employeeIdController.text.trim();
    if (_payrollRecords.any((r) => r.employeeId == empId)) {
      _showSnackBar(
        'Payroll for this Employee ID already exists!',
        isError: true,
      );
      return;
    }

    await _loadAttendanceRecords();

    final payroll = PayrollService.computePayroll(empId, _attendanceRecords);
    if (payroll != null) {
      setState(() {
        _payrollRecords.add(payroll);
        _employeeIdController.clear();
      });
      PayrollStorage.saveRecords(_payrollRecords);
    } else {
      _showSnackBar(
        'No attendance data found for this employee.',
        isError: true,
      );
    }
  }

  void _refreshPayroll() async {
    setState(() => _payrollRecords.clear());

    await _loadAttendanceRecords();

    if (_role == 'employee' && _userEmployeeId != null) {
      _generatePayrollForEmployee(_userEmployeeId!);
    } else if (_role == 'admin') {
      _generatePayrollForAllEmployees();
    }

    _showSnackBar('Payroll refreshed based on attendance records.');
  }

  Future<void> _exportToXmlFile() async {
    try {
      final filePath = await XmlHelper.payrollListToXml(_payrollRecords);
      _showSnackBar('Payroll exported to $filePath');
    } catch (e) {
      _showSnackBar('Export failed: $e', isError: true);
    }
  }

  void _clearRecords() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Delete all payroll records for today?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _payrollRecords.clear());
              PayrollStorage.clearRecords();
              _showSnackBar('Payroll cleared.');
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = _role == 'employee';
    final filteredRecords = isEmployee && _userEmployeeId != null
        ? _payrollRecords.where((r) => r.employeeId == _userEmployeeId).toList()
        : _payrollRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to XML',
            onPressed: _exportToXmlFile,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        child: Column(
          children: [
            if (!isEmployee) _buildAdminControls(),
            const SizedBox(height: 20),
            Expanded(child: _buildPayrollList(filteredRecords)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminControls() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _employeeIdController,
            decoration: const InputDecoration(
              labelText: 'Employee ID',
              filled: true,
              fillColor: Colors.white70,
            ),
            validator: (value) => value!.isEmpty ? 'Enter employee ID' : null,
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
                  onPressed: _refreshPayroll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text('Refresh Payroll'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _clearRecords,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Clear Today's List"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollList(List<PayrollRecord> records) {
    if (records.isEmpty) {
      return const Center(child: Text('No payroll records found.'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text('Employee ID: ${record.employeeId}'),
                  subtitle: Text(
                    'Hours: ${record.hoursWorked.toStringAsFixed(2)}\n'
                    'Salary: ₱${record.totalSalary.toStringAsFixed(2)}\n'
                    'Date: ${DateFormat.yMMMd().format(record.dateGenerated)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Payroll Record'),
                          content: const Text(
                            'Are you sure you want to delete this payroll record? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        setState(() => records.removeAt(index));
                        PayrollStorage.saveRecords(records);
                        _showSnackBar('Payroll record deleted.');
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPayrollScreen(
                  payrollRecords: _payrollRecords,
                  isEmployee: false,
                ),
              ),
            );
          },
          child: const Text('View All'),
        ),
      ],
    );
  }
}
