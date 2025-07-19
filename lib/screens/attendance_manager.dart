import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/screens/attendance_list_screen.dart';
import 'package:final_project_in_appdev/utils/xml_helper.dart';
import 'package:final_project_in_appdev/utils/file_exporter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Main widget for managing attendance
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
  String? _lastExportPath;

  List<AttendanceRecord> _attendanceRecords = [];

  // Load saved attendance on start
  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  // Loads attendance records from SharedPreferences
  Future<void> _loadAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final xmlData = prefs.getString('attendance_records');
    if (xmlData != null) {
      final records = XmlHelper.fromXml(xmlData);
      setState(() {
        _attendanceRecords = records;
      });
    }
  }

  // Saves attendance records to SharedPreferences as XML
  Future<void> _saveAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final xmlData = XmlHelper.toXml(_attendanceRecords);
    await prefs.setString('attendance_records', xmlData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance list saved as XML.')),
    );
  }

  // Clears all attendance records
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

  // Adds a new attendance record if not duplicate
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

  // Opens date picker dialog
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

  // Exports attendance records to XML file
  Future<void> _exportToXml() async {
    try {
      final filePath = await XmlHelper.exportRecordsToXml(_attendanceRecords);
      setState(() => _lastExportPath = filePath);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('XML exported to $filePath')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to export XML: \$e')));
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
            // Attendance input form
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
                        // Employee ID input
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
                        // Date picker row
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
                        // Attendance status dropdown
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
                        // Add Attendance button
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
            // List of attendance records
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
            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Save attendance list
                ElevatedButton(
                  onPressed: _saveAttendance,
                  child: const Text('Save List'),
                ),
                // Clear attendance list
                ElevatedButton(
                  onPressed: _clearAttendance,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Clear List'),
                ),
                // View attendance list in a new screen
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
                // Export attendance list to XML
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Export to XML'),
                  onPressed: _exportToXml,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                // Show file path if exported
                if (_lastExportPath != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    'File saved at:\n$_lastExportPath',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
