import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Colors.grey[50];
  static const Color textColor = Colors.grey[800];

  // Fonts
  static const String fontFamily = 'Roboto';
  static const double fontSizeTitle = 24;
  static const double fontSizeSubtitle = 18;

  // API URLs
  static const String baseUrl = 'https://your-api-url.com';

  // Navigation Routes
  static const String loginRoute = '/login';
  static const String signUpRoute = '/sign-up';
  static const String dashboardRoute = '/dashboard';
  static const String employeeManagementRoute = '/employee-management';
  static const String attendanceManagerRoute = '/attendance-manager';
  static const String payrollReportRoute = '/payroll-report';
  static const String profileRoute = '/profile';
}