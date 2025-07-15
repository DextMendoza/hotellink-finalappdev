import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/screens/attendance_list_screen.dart';

class AttendanceManager extends StatefulWidget {
  const AttendanceManager({super.key});

  @override
  State<AttendanceManager> createState() => _AttendanceManagerState();
}

class _AttendanceManagerState extends State<AttendanceManager> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _attendanceStatus = 'Present';

  List<AttendanceRecord> _attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('attendance_records');
    if (data != null) {
      final List<dynamic> decoded = json.decode(data);
      setState(() {
        _attendanceRecords = decoded
            .map((e) => AttendanceRecord.fromJson(e))
            .toList();
      });
    }
  }

  Future<void> _saveAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(
      _attendanceRecords.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('attendance_records', data);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Attendance list saved.')));
  }

  Future<void> _clearAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('attendance_records');
    setState(() {
      _attendanceRecords.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Attendance list cleared.')));
  }

  void _addAttendance() {
    if (_formKey.currentState!.validate()) {
      // Checking for duplicate attendance for the same employee and date
      final alreadyExists = _attendanceRecords.any(
        (record) =>
            record.employeeId == _employeeIdController.text &&
            record.date.split('T')[0] ==
                _selectedDate.toIso8601String().split('T')[0],
      );
      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Attendance for this employee on this date already exists.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final record = AttendanceRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: _employeeIdController.text,
        date: _selectedDate.toIso8601String(),
        status: _attendanceStatus,
      );
      setState(() {
        _attendanceRecords.add(record);
      });
      _employeeIdController.clear();
      _attendanceStatus = 'Present';
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance Manager')),
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
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _employeeIdController,
                          decoration: const InputDecoration(
                            labelText: 'Employee ID',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Enter Employee ID' : null,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}',
                              ),
                            ),
                            TextButton(
                              onPressed: _pickDate,
                              child: const Text('Select Date'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: _attendanceStatus,
                          items: const [
                            DropdownMenuItem(
                              value: 'Present',
                              child: Text('Present'),
                            ),
                            DropdownMenuItem(
                              value: 'Absent',
                              child: Text('Absent'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _attendanceStatus = value!);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Attendance Status',
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _attendanceRecords.length,
                itemBuilder: (context, index) {
                  final record = _attendanceRecords[index];
                  return ListTile(
                    tileColor: const Color.fromARGB(179, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text('Employee ID: ${record.employeeId}'),
                    subtitle: Text(
                      'Date: ${record.date.split("T")[0]}, Status: ${record.status}',
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _saveAttendance,
                  child: const Text('Save List'),
                ),
                ElevatedButton(
                  onPressed: _clearAttendance,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear List'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AttendanceListScreen(records: _attendanceRecords),
                      ),
                    );
                  },
                  child: const Text('View List'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
