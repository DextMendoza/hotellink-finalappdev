// file_exporter.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:final_project_in_appdev/models/attendance_record.dart';

class FileExporter {
  static Future<String?> exportToXml(List<AttendanceRecord> records) async {
    try {
      final builder = xml.XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element('AttendanceRecords', nest: () {
        for (final record in records) {
          builder.element('Record', nest: () {
            builder.element('ID', nest: record.id);
            builder.element('EmployeeID', nest: record.employeeId);
            builder.element('Date', nest: record.date);
            builder.element('Status', nest: record.status);
          });
        }
      });

      final xmlString = builder.buildDocument().toXmlString(pretty: true);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/attendance_records.xml';
      final file = File(filePath);
      await file.writeAsString(xmlString);

      return filePath;
    } catch (e) {
      print('Export to XML failed: \$e');
      return null;
    }
  }
}
