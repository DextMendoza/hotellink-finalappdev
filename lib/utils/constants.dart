import 'package:flutter/material.dart';

class Constants {
  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.grey;
  static const Color backgroundColor = Color.fromARGB(243, 250, 250, 250);
  static const Color textColor = Color.fromARGB(255, 66, 66, 66);

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

  //Additional Constants
  static final emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'
  );
  static const backgroundGradient = LinearGradient( //constant for gradient background
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 53, 155, 202),
      Color.fromARGB(255, 49, 118, 150), 
    ],
  );
  


}
