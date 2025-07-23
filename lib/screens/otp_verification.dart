import 'package:flutter/material.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String correctOtp;
  final VoidCallback onVerified;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.correctOtp,
    required this.onVerified,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  String? _errorText;
  bool _isVerifying = false;

  void _verifyOtp() {
    setState(() {
      _isVerifying = true;
      _errorText = null;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_otpController.text.trim() == widget.correctOtp.trim()) {
        widget.onVerified();
      } else {
        setState(() {
          _errorText = 'Invalid OTP. Please try again.';
          _isVerifying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 72, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              'Enter the verification code sent. Check your inbox, or contact main admin if you are registering for an admin role.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                errorText: _errorText,
              ),
            ),
            const SizedBox(height: 20),
            _isVerifying
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyOtp,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Verify'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
