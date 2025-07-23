import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class XmlHelper {
  // ----------- ATTENDANCE ----------

  static String attendanceListToXml(List<AttendanceRecord> records) {
    try {
      if (records.isEmpty) throw Exception('No attendance records provided');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('AttendanceRecords', nest: () {
        for (var record in records) {
          builder.element('Record', nest: () {
            builder.element('EmployeeId', nest: record.employeeId);
            builder.element('Email', nest: record.email);
            builder.element('Date', nest: record.date.toIso8601String());
            builder.element('Status', nest: record.status);
            builder.element('TimeIn', nest: record.timeIn);
            builder.element('TimeOut', nest: record.timeOut);
          });
        }
      });

      return builder.buildDocument().toXmlString(pretty: true);
    } catch (e) {
      throw Exception('Attendance XML generation failed: $e');
    }
  }

  static Future<String> exportAttendanceToXml(List<AttendanceRecord> records) async {
    try {
      final xmlString = attendanceListToXml(records);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.xml');
      await file.writeAsString(xmlString);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export attendance records: $e');
    }
  }

  static List<AttendanceRecord> parseAttendanceXml(String xmlString) {
    try {
      if (xmlString.isEmpty) throw Exception('Empty XML string');
      final document = XmlDocument.parse(xmlString);
      return document.findAllElements('Record').map((element) {
        return AttendanceRecord(
          employeeId: element.getElement('EmployeeId')?.text ?? '',
          email: element.getElement('Email')?.text ?? '',
          date: DateTime.parse(element.getElement('Date')?.text ?? ''),
          status: element.getElement('Status')?.text ?? '',
          timeIn: element.getElement('TimeIn')?.text ?? '',
          timeOut: element.getElement('TimeOut')?.text ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to parse attendance XML: $e');
    }
  }

  static Future<List<AttendanceRecord>> importAttendanceFromXmlFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) throw Exception('Attendance file not found');
      final xmlString = await file.readAsString();
      return parseAttendanceXml(xmlString);
    } catch (e) {
      throw Exception('Failed to import attendance XML: $e');
    }
  }

  // ----------- EMPLOYEE ----------

  static String employeeListToXml(List<Employee> employees) {
    try {
      if (employees.isEmpty) throw Exception('No employee records provided');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('Employees', nest: () {
        for (var employee in employees) {
          builder.element('Employee', nest: () {
            builder.element('Name', nest: employee.name);
            builder.element('Position', nest: employee.position);
            builder.element('Email', nest: employee.email);
            builder.element('EmployeeId', nest: employee.employeeId);
          });
        }
      });

      return builder.buildDocument().toXmlString(pretty: true);
    } catch (e) {
      throw Exception('Employee XML generation failed: $e');
    }
  }

  static Future<String> exportEmployeesToXml(List<Employee> employees) async {
    try {
      final xmlString = employeeListToXml(employees);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/employees_${DateTime.now().millisecondsSinceEpoch}.xml');
      await file.writeAsString(xmlString);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export employees: $e');
    }
  }

  // ----------- PAYROLL ----------

  static String payrollListToXml(List<PayrollRecord> payrollList) {
    try {
      if (payrollList.isEmpty) throw Exception('No payroll records provided');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('PayrollReport', nest: () {
        for (var item in payrollList) {
          builder.element('PayrollItem', nest: () {
            builder.element('EmployeeId', nest: item.employeeId);
            builder.element('DateGenerated', nest: item.dateGenerated.toIso8601String());
            builder.element('HoursWorked', nest: item.hoursWorked.toString());
            builder.element('TotalSalary', nest: item.totalSalary.toString());
          });
        }
      });

      return builder.buildDocument().toXmlString(pretty: true);
    } catch (e) {
      throw Exception('Payroll XML generation failed: $e');
    }
  }

  static Future<String> exportPayrollToXml(List<PayrollRecord> records) async {
    try {
      final xmlString = payrollListToXml(records);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/payroll_${DateTime.now().millisecondsSinceEpoch}.xml');
      await file.writeAsString(xmlString);
      return file.path;
    } catch (e) {
      throw Exception('Failed to export payroll records: $e');
    }
  }
}
