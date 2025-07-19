import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

// Screen to display a list and shows the list of attendance records.
class AttendanceListScreen extends StatelessWidget {
  final List<AttendanceRecord> records;

  // Constructor requires a list of attendance records.
  const AttendanceListScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
        actions: [
          // Button to clear all records (handled by parent via pop)
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, 'clear');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(16),
        child: records.isEmpty
            // Show message if no records
            ? const Center(
                child: Text(
                  'No attendance records available.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            // Otherwise, show the list of records
            : ListView.separated(
                itemCount: records.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: record.status == 'Present'
                          ? Colors.green
                          : Colors.red,
                      child: Icon(
                        record.status == 'Present' ? Icons.check : Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    // Employee ID
                    title: Text(
                      'Employee ID: ${record.employeeId}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    // Date and status
                    subtitle: Text(
                      'Date: ${record.date.split("T")[0]}\nStatus: ${record.status}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
