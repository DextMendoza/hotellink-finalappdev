import 'package:flutter/material.dart';
import 'package:final_project_in_appdev/screens/dashboard.dart';
import 'package:final_project_in_appdev/screens/sign_up_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';
import 'package:final_project_in_appdev/utils/account_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Handles login logic
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Check credentials
      final isValid = await AccountStorage.verifyCredentials(
        _emailController.text,
        _passwordController.text,
      );

      if (isValid) {
        // Save user info to secure storage
        final user = await AccountStorage.getUserByEmail(_emailController.text);
        if (user != null) {
          await FlutterSecureStorage().write(
            key: 'current_user_email',
            value: user.email,
          );
          await FlutterSecureStorage().write(
            key: 'current_user_name',
            value: user.name,
          );
        }

        // Navigate to dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      } else {
        setState(() => _isLoading = false);
        // Show invalid input
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Login screen UI
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // App logo
                  Image.asset('assets/images/logo.png', width: 80, height: 80),
                  const SizedBox(height: 20),
                  // App title
                  Text(
                    'HotelLink: HRIS',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Email input
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter your email';
                      if (!Constants.emailRegex.hasMatch(value))
                        return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Password input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Enter your password'
                        : null,
                  ),
                  const SizedBox(height: 30),
                  // Login button or loading indicator
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text('Login'),
                        ),
                  const SizedBox(height: 20),
                  // Link to sign up screen
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
