import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/utils/attendance_storage.dart';

class AttendanceManager extends StatefulWidget {
  const AttendanceManager({super.key});

  @override
  State<AttendanceManager> createState() => _AttendanceManagerState();
}

class _AttendanceManagerState extends State<AttendanceManager> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _timeInController = TextEditingController();
  final _timeOutController = TextEditingController();
  final _secureStorage = const FlutterSecureStorage();

  List<AttendanceRecord> _records = [];
  DateTime _selectedDate = DateTime.now();
  String _status = 'Present';
  String? _role;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserRoleAndData();
  }

  Future<void> _loadUserRoleAndData() async {
    final email = await _secureStorage.read(key: 'current_user_email');
    final role = await _secureStorage.read(key: 'current_user_role');

    setState(() {
      _role = role;
      _userEmail = email;
    });

    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final allRecords = await AttendanceStorage.loadRecords();
    setState(() {
      _records = _role == 'employee'
          ? allRecords.where((r) => r.email == _userEmail).toList()
          : allRecords;
    });
  }

  Future<void> _saveAttendance() async {
    await AttendanceStorage.saveRecords(_records);
  }

  void _addAttendance() {
    if (!_formKey.currentState!.validate()) return;

    final employeeId = _role == 'employee'
        ? _userEmail ?? 'unknown'
        : _employeeIdController.text.trim();

    final alreadyExists = _records.any((r) =>
        r.employeeId == employeeId &&
        r.date.year == _selectedDate.year &&
        r.date.month == _selectedDate.month &&
        r.date.day == _selectedDate.day);

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance already recorded for this employee and date.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newRecord = AttendanceRecord(
      employeeId: employeeId,
      email: _userEmail ?? 'unknown',
      date: _selectedDate,
      status: _status,
      timeIn: _timeInController.text.trim(),
      timeOut: _timeOutController.text.trim(),
    );

    setState(() {
      _records.add(newRecord);
    });

    _clearFormFields();
    _saveAttendance();
  }

  void _clearFormFields() {
    setState(() {
      _employeeIdController.clear();
      _timeInController.clear();
      _timeOutController.clear();
      _selectedDate = DateTime.now();
      _status = 'Present';
    });
  }

  Future<void> _deleteAllAttendance() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Attendance?'),
        content: const Text('This will permanently delete all attendance records. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        if (_role == 'employee') {
          _records.removeWhere((r) => r.email == _userEmail);
        } else {
          _records.clear();
        }
      });
      await _saveAttendance();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _role == 'employee'
                ? 'Your attendance records deleted.'
                : 'All attendance records deleted.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime({required bool isTimeIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formatted = picked.format(context);
      setState(() {
        if (isTimeIn) {
          _timeInController.text = formatted;
        } else {
          _timeOutController.text = formatted;
        }
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, {IconData? icon}) {
    return TextFormField(
      controller: controller,
      readOnly: icon != null,
      validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _timeInController.dispose();
    _timeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmployee = _role == 'employee';

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Manager')),
      body: _role == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!isEmployee)
                          _buildTextField(_employeeIdController, 'Employee ID'),
                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () => _pickTime(isTimeIn: true),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              _timeInController,
                              'Select Time In',
                              icon: Icons.access_time,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        GestureDetector(
                          onTap: () => _pickTime(isTimeIn: false),
                          child: AbsorbPointer(
                            child: _buildTextField(
                              _timeOutController,
                              'Select Time Out',
                              icon: Icons.access_time,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                            ),
                            TextButton(
                              onPressed: _pickDate,
                              child: const Text('Pick Date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        DropdownButtonFormField<String>(
                          value: _status,
                          items: const [
                            DropdownMenuItem(value: 'Present', child: Text('Present')),
                            DropdownMenuItem(value: 'Absent', child: Text('Absent')),
                          ],
                          onChanged: (val) => setState(() => _status = val!),
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: _addAttendance,
                          child: const Text('Add Attendance'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: _records.isEmpty
                        ? const Text('No attendance records found.')
                        : ListView.builder(
                            itemCount: _records.length,
                            itemBuilder: (context, index) {
                              final r = _records[index];
                              final dateStr = r.date.toLocal().toString().split(' ')[0];
                              return ListTile(
                                title: Text('ID: ${r.employeeId}'),
                                subtitle: Text('Date: $dateStr | Status: ${r.status}\nIn: ${r.timeIn} - Out: ${r.timeOut}'),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),

                  if (!isEmployee)
                    ElevatedButton(
                      onPressed: _clearFormFields,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text('Clear Form'),
                    ),
                  ElevatedButton(
                    onPressed: _deleteAllAttendance,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(isEmployee ? 'Delete My Records' : 'Delete All Records'),
                  ),
                ],
              ),
            ),
    );
  }
}
