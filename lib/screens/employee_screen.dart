import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

// Displays a list of all employees passed to this screen.
class EmployeeScreen extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeScreen({
    super.key,
    required this.employees,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Employees')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: Constants.backgroundGradient,
        ),
        child: employees.isEmpty
            ? const Center(
                child: Text(
                  'No employees added yet.',
                  style: TextStyle(color: Colors.white),
                ),
              )
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
      ),
    );
  }
}
