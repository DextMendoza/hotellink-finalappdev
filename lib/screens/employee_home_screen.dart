import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_screen.dart';
import 'package:final_project_in_appdev/screens/attendance_list_screen.dart';
import 'package:final_project_in_appdev/utils/payroll_storage.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';
import 'dart:ui';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  int _selectedIndex = 0; // Set default to Attendance or Payroll

  void _openPayroll(BuildContext context) async {
    List<PayrollRecord> allRecords = await PayrollStorage.loadRecords();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ViewPayrollScreen(payrollRecords: allRecords, isEmployee: true),
      ),
    );
  }

  void _openAttendanceList(BuildContext context) {
    // Replace with actual attendance records if available
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AttendanceListScreen(records: const []),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      // Navigate to AttendanceManager for employees
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AttendanceManager()),
      );
    } else if (index == 1) {
      _openPayroll(context);
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
    // No Home tab
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/emp_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Add blur effect over the background image
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.transparent),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Employee Dashboard'),
              backgroundColor: Colors.blue,
              automaticallyImplyLeading: false,
            ),
            body: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                _TileButton(
                  icon: Icons.access_time,
                  label: 'Log Attendance',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AttendanceManager(),
                      ),
                    );
                  },
                ),
                _TileButton(
                  icon: Icons.receipt_long,
                  label: 'View Payroll',
                  onTap: () => _openPayroll(context),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              onTap: _onBottomNavTap,
              type: BottomNavigationBarType.fixed,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'Attendance',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long),
                  label: 'Payroll',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TileButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
