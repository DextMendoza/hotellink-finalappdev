import 'package:final_project_in_appdev/screens/employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';
import 'package:final_project_in_appdev/screens/sign_up_screen.dart';
import 'package:final_project_in_appdev/screens/dashboard.dart';
import 'package:final_project_in_appdev/screens/employee_management.dart';
import 'package:final_project_in_appdev/screens/attendance_manager.dart';
import 'package:final_project_in_appdev/screens/payroll_management.dart';
import 'package:final_project_in_appdev/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up MaterialApp with routes and theme
    return MaterialApp(
      title: 'HotelLink Mobile App',
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
        '/employee-screen': (context) => EmployeeScreen(employees: []),
      },
    );
  }
}

// Splash screen shown at app start
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds then go to login screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple splash UI with app name and loading spinner
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'HotelLink Mobile App',
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
