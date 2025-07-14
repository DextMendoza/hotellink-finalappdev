import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/employee_management.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_report.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';

class Dashboard extends StatefulWidget {
  final String email;
  final String name;

  const Dashboard({
    super.key,
    this.email = '',  // Make optional with default value
    this.name = '',   // Make optional with default value
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    email: widget.email,
                    name: widget.name,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const NavigationDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmployeeManagement(),
                  ),
                );
              },
              child: const Text('Employee Management'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AttendanceManager(),
                  ),
                );
              },
              child: const Text('Attendance Manager'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PayrollReport(),
                  ),
                );
              },
              child: const Text('Payroll Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Payroll Management',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Employee Management'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployeeManagement(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Attendance Manager'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttendanceManager(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Payroll Report'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayrollReport(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(
                    email: 'admin@example.com',
                    name: 'Admin User',
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}