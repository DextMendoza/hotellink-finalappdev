import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:final_project_in_appdev/models/attendance_record.dart';
import 'package:final_project_in_appdev/models/employee.dart';
import 'package:final_project_in_appdev/models/payroll_record.dart';

class XmlHelper {
  // ----------- ATTENDANCE ----------

  static String toXml(List<AttendanceRecord> records) {
    try {
      if (records.isEmpty) throw Exception('No records provided');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('AttendanceRecords', nest: () {
        for (var record in records) {
          builder.element('Record', nest: () {
            builder.element('Id', nest: record.id);
            builder.element('EmployeeId', nest: record.employeeId);
            builder.element('Date', nest: record.date);
            builder.element('Status', nest: record.status);
          });
        }
      });

      final xmlString = builder.buildDocument().toXmlString(pretty: true);
      if (xmlString.isEmpty) throw Exception('Generated XML is empty');

      return xmlString;
    } catch (e) {
      throw Exception('XML generation failed: $e');
    }
  }

  static Future<String> exportRecordsToXml(List<AttendanceRecord> records) async {
    try {
      final xmlString = toXml(records);
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/attendance_$timestamp.xml');
      await file.writeAsString(xmlString);
      if (!await file.exists()) throw Exception('File was not created');
      return file.path;
    } catch (e) {
      throw Exception('Failed to export records: $e');
    }
  }

  static List<AttendanceRecord> fromXml(String xmlString) {
    try {
      if (xmlString.isEmpty) throw Exception('Empty XML string');
      final document = XmlDocument.parse(xmlString);
      final records = document.findAllElements('Record').map((element) {
        return AttendanceRecord(
          id: element.getElement('Id')?.text ?? '',
          employeeId: element.getElement('EmployeeId')?.text ?? '',
          date: element.getElement('Date')?.text ?? '',
          status: element.getElement('Status')?.text ?? '',
        );
      }).toList();

      if (records.isEmpty) throw Exception('No records found in XML');
      return records;
    } catch (e) {
      throw Exception('Failed to parse XML: $e');
    }
  }

  static Future<List<AttendanceRecord>> importRecordsFromXmlFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) throw Exception('File not found at $path');
      final xmlString = await file.readAsString();
      return fromXml(xmlString);
    } catch (e) {
      throw Exception('Failed to import records: $e');
    }
  }

  // ----------- EMPLOYEES ----------

  static String employeeListToXml(List<Employee> employees) {
    try {
      if (employees.isEmpty) throw Exception('No employees to export');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('Employees', nest: () {
        for (var emp in employees) {
          builder.element('Employee', nest: () {
            builder.element('Id', nest: emp.id);
            builder.element('EmployeeId', nest: emp.employeeId);
            builder.element('Name', nest: emp.name);
            builder.element('Email', nest: emp.email);
            builder.element('Salary', nest: emp.salary.toString());
          });
        }
      });

      final xmlString = builder.buildDocument().toXmlString(pretty: true);
      if (xmlString.isEmpty) throw Exception('Generated XML is empty');
      return xmlString;
    } catch (e) {
      throw Exception('Failed to generate employee XML: $e');
    }
  }

  static Future<String> exportEmployeesToXml(List<Employee> employees) async {
    try {
      final xmlString = employeeListToXml(employees);
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/employees_$timestamp.xml');
      await file.writeAsString(xmlString);
      if (!await file.exists()) throw Exception('File was not created');
      return file.path;
    } catch (e) {
      throw Exception('Failed to export employees: $e');
    }
  }

  static Future<List<Employee>> importEmployeesFromXmlFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) throw Exception('Employee file not found at $path');
      final xmlString = await file.readAsString();
      return employeeListFromXml(xmlString);
    } catch (e) {
      throw Exception('Failed to import employees: $e');
    }
  }

  static List<Employee> employeeListFromXml(String xmlString) {
    try {
      if (xmlString.isEmpty) throw Exception('Empty XML string');
      final document = XmlDocument.parse(xmlString);
      final employees = document.findAllElements('Employee').map((element) {
        return Employee(
          id: element.getElement('Id')?.text ?? '',
          employeeId: element.getElement('EmployeeId')?.text ?? '',
          name: element.getElement('Name')?.text ?? '',
          email: element.getElement('Email')?.text ?? '',
          salary: double.tryParse(element.getElement('Salary')?.text ?? '0') ?? 0,
        );
      }).toList();

      if (employees.isEmpty) throw Exception('No employees found in XML');
      return employees;
    } catch (e) {
      throw Exception('Failed to parse employee XML: $e');
    }
  }

  // ----------- PAYROLL ----------

  static String payrollListToXml(List<PayrollRecord> payrollList) {
    try {
      if (payrollList.isEmpty) throw Exception('No payroll items to export');

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('PayrollReport', nest: () {
        for (var item in payrollList) {
          builder.element('PayrollItem', nest: () {
            builder.element('EmployeeId', nest: item.employeeId);
            builder.element('Date', nest: item.month);
            builder.element('Salary', nest: item.salary.toString());
          });
        }
      });

      final xmlString = builder.buildDocument().toXmlString(pretty: true);
      if (xmlString.isEmpty) throw Exception('Generated XML is empty');
      return xmlString;
    } catch (e) {
      throw Exception('Failed to generate payroll XML: $e');
    }
  }

  static Future<String> exportPayrollToXml(List<PayrollRecord> payrollList) async {
    try {
      final xmlString = payrollListToXml(payrollList);
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/payroll_$timestamp.xml');
      await file.writeAsString(xmlString);
      if (!await file.exists()) throw Exception('File was not created');
      return file.path;
    } catch (e) {
      throw Exception('Failed to export payroll: $e');
    }
  }
}

//web export
