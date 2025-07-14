import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';
import 'package:final_project_in_appdev/screens/sign_up_screen.dart';
import 'package:final_project_in_appdev/screens/dashboard.dart';
import 'package:final_project_in_appdev/screens/employee_management.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_report.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payroll Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/dashboard': (context) => const Dashboard(),
        '/employee-management': (context) => const EmployeeManagement(),
        '/attendance-manager': (context) => const AttendanceManager(),
        '/payroll-report': (context) => const PayrollReport(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Payroll Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
