import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Account {
  final String name;
  final String email;
  final String password;

  Account({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
      };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        name: json['name'],
        email: json['email'],
        password: json['password'],
      );
}

class AccountStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'accounts';

  static Future<void> saveAccount(String name, String email, String password) async {
    final accounts = await loadAccounts();
    accounts[email] = Account(name: name, email: email, password: password);
    final encoded = jsonEncode(
      accounts.map((key, account) => MapEntry(key, account.toJson())),
    );
    await _storage.write(key: _key, value: encoded);
  }

  static Future<Map<String, Account>> loadAccounts() async {
    final jsonString = await _storage.read(key: _key);
    if (jsonString == null || jsonString.isEmpty) return {};

    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((key, value) => MapEntry(key, Account.fromJson(value)));
  }

  static Future<bool> verifyCredentials(String email, String password) async {
    final accounts = await loadAccounts();
    final account = accounts[email];
    return account != null && account.password == password;
  }

  static Future<Account?> getUserByEmail(String email) async {
    final accounts = await loadAccounts();
    return accounts[email];
  }
}
