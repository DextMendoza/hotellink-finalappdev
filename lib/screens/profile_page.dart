import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:final_project_in_appdev/screens/login_screen.dart';
import 'package:final_project_in_appdev/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _secureStorage = const FlutterSecureStorage();
  String _name = 'Loading...';
  String _email = 'Loading...';

  // Load user profile data on start
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load name and email from secure storage
  Future<void> _loadProfileData() async {
    final name = await _secureStorage.read(key: 'current_user_name');
    final email = await _secureStorage.read(key: 'current_user_email');

    if (!mounted) return;

    setState(() {
      _name = name?.isNotEmpty == true ? name! : 'Unknown';
      _email = email?.isNotEmpty == true ? email! : 'Unknown';
    });
  }

  // Logout and clear secure storage
  Future<void> _logout() async {
    await _secureStorage.deleteAll();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Profile page UI
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Container(
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 40.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Image.asset('assets/images/logo.png', width: 80, height: 80),
                const SizedBox(height: 20),
                // Profile info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(213, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: $_name',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: $_email',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Logout button
                ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
