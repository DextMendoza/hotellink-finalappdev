import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class AttendanceListScreen extends StatelessWidget {
  final List<AttendanceRecord> records;

  const AttendanceListScreen({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, 'clear');
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(16),
        child: records.isEmpty
            ? const Center(
                child: Text(
                  'No attendance records available.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: records.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: record.status == 'Present' ? Colors.green : Colors.red,
                      child: Icon(
                        record.status == 'Present' ? Icons.check : Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Employee ID: ${record.employeeId}',
                      style: const TextStyle(color: Colors.white),
                    ),
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
