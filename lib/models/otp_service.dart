import 'dart:convert';
import 'package:http/http.dart' as http;

class OtpService {
  static Future<String?> sendOtp(String email) async {
    const serviceId = '';
    const templateId = '';
    const userId = ''; // public key from EmailJS
    final otp = _generateOtp();

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

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
        'template_params': {
          'to_email': email,
          'otp': otp,
        },
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
