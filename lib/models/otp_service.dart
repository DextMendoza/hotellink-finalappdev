import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  // This sends an OTP either to the user (employee) or to the admin (for admin signups)
  static Future<String?> sendOtp(String recipientEmail, String role) async {
    const serviceId = '';
    const employeeTemplateId = '';
    const adminTemplateId = '';
    const userId = ''; // EmailJS public key

    final otp = _generateOtp();
    final templateId = role == 'admin' ? adminTemplateId : employeeTemplateId;

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    final templateParams = {
      'to_email': role == 'admin'
          ? '' // email of the main admin reviewer
          : recipientEmail, // send to employee if role is employee
      'otp': otp,
      'user_email': recipientEmail, // include in message for admin approval
    };

    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': templateParams,
      }),
    );

    if (response.statusCode == 200) {
      return otp;
    } else {
      print('Failed to send OTP: ${response.body}');
      return null;
    }
  }

  static String _generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return (random % 1000000).toString().padLeft(6, '0');
  }
}
