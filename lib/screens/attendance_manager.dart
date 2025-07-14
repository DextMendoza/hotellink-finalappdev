import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';

class AttendanceManager extends StatefulWidget {
  const AttendanceManager({super.key});

  @override
  State<AttendanceManager> createState() => _AttendanceManagerState();
}

class _AttendanceManagerState extends State<AttendanceManager> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _dateController = TextEditingController();
  final _statusController = TextEditingController();
  List<AttendanceRecord> _attendanceRecords = [];

  @override
  void dispose() {
    _employeeIdController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _addAttendance() {
    if (_formKey.currentState!.validate()) {
      final attendanceRecord = AttendanceRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: _employeeIdController.text,
        date: _dateController.text,
        status: _statusController.text,
      );
      setState(() {
        _attendanceRecords.add(attendanceRecord);
      });
      _employeeIdController.clear();
      _dateController.clear();
      _statusController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Manager'),
      ),
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
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      labelText: 'Attendance Status',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter attendance status';
                      }
                      return null;
                    },
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
              child: ListView.builder(
                itemCount: _attendanceRecords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        'Employee ID: ${_attendanceRecords[index].employeeId}'),
                    subtitle: Text(
                        'Date: ${_attendanceRecords[index].date}, Status: ${_attendanceRecords[index].status}'),
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