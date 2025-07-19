// Updated EmployeeManagement screen with XML export integration and download confirmation

import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/screens/employee_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/employee_storage.dart';
import 'package:final_project_in_appdev/utils/xml_helper.dart'; // New XML helper
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EmployeeManagement extends StatefulWidget {
  const EmployeeManagement({super.key});

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final _formKey = GlobalKey<FormState>();
  final _employeeIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _salaryController = TextEditingController();
  List<Employee> _employees = [];
  int? _editingIndex;
  String? _lastExportPath;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  // Loads employees from storage.
  Future<void> _loadEmployees() async {
    final loadedEmployees = await EmployeeStorage.loadEmployees();
    setState(() => _employees = loadedEmployees);
  }

  // Clears the employee form.
  void _clearForm() {
    _employeeIdController.clear();
    _nameController.clear();
    _emailController.clear();
    _salaryController.clear();
    _editingIndex = null;
  }

  // Saves a new or edited employee.
  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: _editingIndex != null
            ? _employees[_editingIndex!].id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        employeeId: _employeeIdController.text,
        name: _nameController.text,
        email: _emailController.text,
        salary: double.parse(_salaryController.text),
      );

      setState(() {
        if (_editingIndex != null) {
          _employees[_editingIndex!] = employee;
        } else {
          _employees.add(employee);
        }
      });

      await EmployeeStorage.saveEmployees(_employees);
      _clearForm();
    }
  }

  // Deletes an employee at the given index.
  Future<void> _deleteEmployee(int index) async {
    setState(() => _employees.removeAt(index));
    await EmployeeStorage.saveEmployees(_employees);
  }

  // Populates the form with the selected employee's data for editing.
  void _populateForm(Employee emp, int index) {
    _employeeIdController.text = emp.employeeId;
    _nameController.text = emp.name;
    _emailController.text = emp.email;
    _salaryController.text = emp.salary.toString();
    _editingIndex = index;
  }

  // Exports employees to XML.
  Future<void> _exportToXml() async {
    try {
      final path = await XmlHelper.exportEmployeesToXml(_employees);
      setState(() => _lastExportPath = path);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Exported to XML: $path')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export to XML',
            onPressed: _exportToXml,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Employee input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
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
                          value!.isEmpty ? 'Please enter employee ID' : null,
                    ),
                    const SizedBox(height: 10),
                    // Name input
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 10),
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!Constants.emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Salary input
                    TextFormField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter salary' : null,
                    ),
                    const SizedBox(height: 10),
                    // Add/Update and View Employees buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveEmployee,
                            child: Text(
                              _editingIndex == null
                                  ? 'Add Employee'
                                  : 'Update Employee',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeScreen(employees: _employees),
                                ),
                              );
                            },
                            child: const Text('View Employees'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Employee list
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final emp = _employees[index];
                  return Card(
                    child: ListTile(
                      title: Text(emp.name),
                      subtitle: Text(
                        'ID: ${emp.employeeId} | Email: ${emp.email}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _populateForm(emp, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEmployee(index),
                          ),
                        ],
                      ),
                    ),
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
