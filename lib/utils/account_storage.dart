import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Account {
  final String name;
  final String email;
  final String password;
  final String role;

  Account({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        role: json['role'] ?? 'admin', // fallback
      );
}

class AccountStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'accounts';

  // Load all accounts from secure storage
  static Future<Map<String, Account>> loadAccounts() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null || jsonString.isEmpty) return {};

    final Map<String, dynamic> decoded =
        Map<String, dynamic>.from(jsonDecode(jsonString));

    return decoded.map((key, value) => MapEntry(
        key, Account.fromJson(Map<String, dynamic>.from(value))));
  }

  // Save a single account to secure storage
  static Future<void> saveAccount(
    String name,
    String email,
    String password,
    String role,
  ) async {
    final accounts = await loadAccounts();

    accounts[email] = Account(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    final encoded = jsonEncode(
      accounts.map((key, acc) => MapEntry(key, acc.toJson())),
    );

    await _storage.write(key: _key, value: encoded);
  }

  // Verify credentials during login
  static Future<bool> verifyCredentials(String email, String password) async {
    final accounts = await loadAccounts();
    final account = accounts[email];

    return account != null && account.password == password;
  }

  // Get user info by email
  static Future<Account?> getUserByEmail(String email) async {
    final accounts = await loadAccounts();
    return accounts[email];
  }
}
