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

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await _secureStorage.read(key: 'current_user_name');
    final email = await _secureStorage.read(key: 'current_user_email');

    if (!mounted) return;

    setState(() {
      _name = name?.isNotEmpty == true ? name! : 'Unknown';
      _email = email?.isNotEmpty == true ? email! : 'Unknown';
    });
  }

  Future<void> _logout() async {
    await _secureStorage.delete(key: 'current_user_email');
    await _secureStorage.delete(key: 'current_user_name');
    await _secureStorage.delete(key: 'current_user_role');
    await _secureStorage.delete(key: 'current_user_id');

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _confirmDeleteProfile() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
            'Are you sure you want to delete your profile? This will remove your account data from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final email = await _secureStorage.read(key: 'current_user_email');
      if (email != null && email.isNotEmpty) {
        // Delete only current user's stored data
        await _secureStorage.delete(key: 'user_${email}_name');
        await _secureStorage.delete(key: 'user_${email}_password');
        await _secureStorage.delete(key: 'user_${email}_role');
        await _secureStorage.delete(key: 'user_${email}_id');

        // Clear session keys
        await _secureStorage.delete(key: 'current_user_email');
        await _secureStorage.delete(key: 'current_user_name');
        await _secureStorage.delete(key: 'current_user_role');
        await _secureStorage.delete(key: 'current_user_id');

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: Constants.backgroundGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset('assets/images/logo.png', width: 60),
            ),
            const SizedBox(height: 20),
            Text(
              _name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _email,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Full Name'),
                    subtitle: Text(_name),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email Address'),
                    subtitle: Text(_email),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _confirmDeleteProfile,
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              label: const Text('Delete Profile'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
