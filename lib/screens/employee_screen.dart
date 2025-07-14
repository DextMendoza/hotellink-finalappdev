import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employees = Employee.allEmployees;
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: employees.isEmpty
            ? const Center(child: Text('No employees added yet.'))
            : ListView.separated(
                itemCount: employees.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          employee.name.isNotEmpty ? employee.name[0] : '?',
                        ),
                      ),
                      title: Text(employee.name),
                      subtitle: Text(employee.email),
                      trailing: Text(
                        'Salary: ${employee.salary.toStringAsFixed(2)}',
                      ),
                      onTap: () {
                        // You can add navigation to employee details here
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
