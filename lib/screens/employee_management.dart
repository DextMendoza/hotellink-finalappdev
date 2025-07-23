import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/screens/employee_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/employee_storage.dart';
import 'package:final_project_in_appdev/utils/xml_helper.dart';

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
  final _positionController = TextEditingController(); // Used to store dropdown value

  List<Employee> _employees = [];
  int? _editingIndex;
  String? _lastExportPath;

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
    _positionController.clear();
    _editingIndex = null;
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final generatedId = DateTime.now().millisecondsSinceEpoch.toString();
      final employeeId = _employeeIdController.text.isNotEmpty
          ? _employeeIdController.text
          : generatedId;

      final employee = Employee(
        employeeId: employeeId,
        name: _nameController.text,
        email: _emailController.text,
        position: _positionController.text,
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
    _positionController.text = emp.position;
    _editingIndex = index;
  }

  Future<void> _exportToXml() async {
    try {
      final path = await XmlHelper.exportEmployeesToXml(_employees);
      setState(() => _lastExportPath = path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to XML: $path')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _positionController.dispose();
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
                    TextFormField(
                      controller: _employeeIdController,
                      decoration: const InputDecoration(
                        labelText: 'Employee ID (leave blank to auto-generate)',
                        border: OutlineInputBorder(),
                      ),
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
                    DropdownButtonFormField<String>(
                      value: _positionController.text.isNotEmpty
                          ? _positionController.text
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Position',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Admin',
                          child: Text('Admin'),
                        ),
                        DropdownMenuItem(
                          value: 'Employee',
                          child: Text('Employee'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _positionController.text = value!;
                        });
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please select a position' : null,
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
                      subtitle: Text('ID: ${emp.employeeId} | Email: ${emp.email}'),
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
                            onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this employee?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm == true) {
    _deleteEmployee(index);
  }
},

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
