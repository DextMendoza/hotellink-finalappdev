import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const _serviceId = 'service_kces6fg';
  static const _templateId = 'template_zh5zolj';
  static const _userId = 'DjKZ32hhsQEjPrI3h'; // EmailJS public key

  static Future<void> sendVerificationEmail({
    required String name,
    required String email,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': _serviceId,
        'template_id': _templateId,
        'user_id': _userId,
        'template_params': {
          'from_name': name,
          'from_email': email,
          'to_email': 'dxdtm16@gmail.com', // set this to owner's email
        }
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send email: ${response.body}');
    }
  }
}
