import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/screens/employee_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/employee_storage.dart';

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

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final loadedEmployees = await EmployeeStorage.loadEmployees();
    setState(() => _employees = loadedEmployees);
  }

  void _clearForm() {
    _employeeIdController.clear();
    _nameController.clear();
    _emailController.clear();
    _salaryController.clear();
    _editingIndex = null;
  }

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

  Future<void> _deleteEmployee(int index) async {
    setState(() => _employees.removeAt(index));
    await EmployeeStorage.saveEmployees(_employees);
  }

  void _populateForm(Employee emp, int index) {
    _employeeIdController.text = emp.employeeId;
    _nameController.text = emp.name;
    _emailController.text = emp.email;
    _salaryController.text = emp.salary.toString();
    _editingIndex = index;
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
      appBar: AppBar(title: const Text('Employee Management')),
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
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter employee ID' : null,
                  ),
                  const SizedBox(height: 10),
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
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveEmployee,
                          child: Text(_editingIndex == null
                              ? 'Add Employee'
                              : 'Update Employee'),
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final emp = _employees[index];
                  return Card(
                    child: ListTile(
                      title: Text(emp.name),
                      subtitle:
                          Text('ID: ${emp.employeeId} | Email: ${emp.email}'),
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
