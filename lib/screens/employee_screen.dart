import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';

class EmployeeScreen extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeScreen({
    super.key,
    required this.employees, // Required parameter
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Employees')),
      body: employees.isEmpty
          ? const Center(child: Text('No employees added yet.'))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final emp = employees[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(emp.name[0]),
                    ),
                    title: Text(emp.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${emp.employeeId}'),
                        Text('Email: ${emp.email}'),
                      ],
                    ),
                    trailing: Text('₱${emp.salary.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
    );
  }
}
