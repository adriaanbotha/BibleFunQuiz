import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final SharedPreferences _prefs;
  static const String _usersKey = 'registered_users';
  
  // Upstash Configuration
  static const String baseUrl = 'https://relative-bison-60370.upstash.io';
  static const String apiKey = 'AevSAAIjcDFkNzY3YjFiZTZhNWI0ZjlhODlkOGE3NTgyOTY3MWQyOHAxMA';

  AuthService(this._prefs);

  // Online Registration
  Future<bool> register(String email, String password) async {
    debugPrint('Attempting online registration with email: $email');
    
    try {
      // First, check if user exists
      final checkUserResponse = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      debugPrint('Check user response: ${checkUserResponse.body}');
      final checkUserData = json.decode(checkUserResponse.body);
      
      // If user exists (not null), return false
      if (checkUserData['result'] != null) {
        debugPrint('User already exists in Upstash');
        return false;
      }

      // Create user data
      final userData = {
        'email': email,
        'password': password,
        'nickname': email.split('@')[0],
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Store user data using SET
      final setUserResponse = await http.post(
        Uri.parse('$baseUrl/set/user:$email/${json.encode(userData)}'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      debugPrint('Set user response: ${setUserResponse.body}');
      final setUserData = json.decode(setUserResponse.body);

      if (setUserResponse.statusCode == 200 && setUserData['result'] == 'OK') {
        debugPrint('User registered successfully in Upstash');
        await _saveLocalUser(userData);
        await listAllUsers(); // Verify storage
        return true;
      }

      debugPrint('Upstash registration failed, status: ${setUserResponse.statusCode}');
      return false;

    } catch (e) {
      debugPrint('Error during online registration: $e');
      debugPrint('Falling back to local registration...');
      return _registerLocally(email, password);
    }
  }

  // Online Login
  Future<bool> login(String email, String password) async {
    debugPrint('Attempting online login with email: $email');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      debugPrint('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['result'] != null) {
          final userData = json.decode(responseData['result']);
          
          if (userData['password'] == password) {
            debugPrint('Online login successful');
            await _saveUserData(email, userData['nickname']);
            return true;
          }
        }
      }

      debugPrint('Online login failed, trying local login...');
      return _loginLocally(email, password);

    } catch (e) {
      debugPrint('Error during online login: $e');
      debugPrint('Falling back to local login...');
      return _loginLocally(email, password);
    }
  }

  // Local Registration
  Future<bool> _registerLocally(String email, String password) async {
    try {
      List<Map<String, String>> users = _getLocalUsers();
      
      if (users.any((user) => user['email'] == email)) {
        debugPrint('User already exists locally');
        return false;
      }

      users.add({
        'email': email,
        'password': password,
        'nickname': email.split('@')[0],
      });

      await _saveLocalUsers(users);
      debugPrint('User registered locally');
      return true;

    } catch (e) {
      debugPrint('Error during local registration: $e');
      return false;
    }
  }

  // Local Login
  Future<bool> _loginLocally(String email, String password) async {
    try {
      List<Map<String, String>> users = _getLocalUsers();
      
      final user = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (user.isNotEmpty) {
        debugPrint('Local login successful');
        await _saveUserData(email, user['nickname'] ?? 'User');
        return true;
      }

      debugPrint('Local login failed');
      return false;

    } catch (e) {
      debugPrint('Error during local login: $e');
      return false;
    }
  }

  // Helper Methods
  List<Map<String, String>> _getLocalUsers() {
    final String? usersJson = _prefs.getString(_usersKey);
    if (usersJson == null) return [];
    
    List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((user) => Map<String, String>.from(user)).toList();
  }

  Future<void> _saveLocalUsers(List<Map<String, String>> users) async {
    await _prefs.setString(_usersKey, json.encode(users));
  }

  Future<void> _saveLocalUser(Map<String, dynamic> userData) async {
    List<Map<String, String>> users = _getLocalUsers();
    users.add(Map<String, String>.from(userData));
    await _saveLocalUsers(users);
  }

  Future<void> _saveUserData(String email, String nickname) async {
    await _prefs.setString('current_user_email', email);
    await _prefs.setString('current_user_nickname', nickname);
  }

  Future<void> logout() async {
    await _prefs.remove('current_user_email');
    await _prefs.remove('current_user_nickname');
  }

  bool isLoggedIn() {
    return _prefs.containsKey('current_user_email');
  }

  String? getNickname() {
    return _prefs.getString('current_user_nickname');
  }

  // For debugging
  Future<void> printUserStatus(String email) async {
    try {
      // Check Upstash
      final response = await http.get(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );
      
      debugPrint('Upstash Status:');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response: ${response.body}');
      
      // Check Local
      final localUsers = _getLocalUsers();
      final localUser = localUsers.firstWhere(
        (user) => user['email'] == email,
        orElse: () => {},
      );
      
      debugPrint('Local Status:');
      debugPrint('User exists locally: ${localUser.isNotEmpty}');
      if (localUser.isNotEmpty) {
        debugPrint('Local user data: $localUser');
      }
      
    } catch (e) {
      debugPrint('Error checking user status: $e');
    }
  }

  Future<bool> checkOnlineStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/ping'),
        headers: {'Authorization': 'Bearer $apiKey'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Online check failed: $e');
      return false;
    }
  }

  // Updated list users method
  Future<void> listAllUsers() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/keys/user:*'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      debugPrint('All users in Upstash:');
      debugPrint('Keys response: ${response.body}');

      final keysData = json.decode(response.body);
      if (keysData['result'] != null && keysData['result'].isNotEmpty) {
        for (String key in keysData['result']) {
          final valueResponse = await http.post(
            Uri.parse('$baseUrl/get/$key'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );
          debugPrint('User data for $key:');
          debugPrint(valueResponse.body);
        }
      } else {
        debugPrint('No users found in Upstash');
      }
    } catch (e) {
      debugPrint('Error listing users: $e');
    }
  }

  // Updated clear users method
  Future<void> clearAllUsers() async {
    try {
      final keysResponse = await http.post(
        Uri.parse('$baseUrl/keys/user:*'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      final keysData = json.decode(keysResponse.body);
      if (keysData['result'] != null && keysData['result'].isNotEmpty) {
        for (String key in keysData['result']) {
          final deleteResponse = await http.post(
            Uri.parse('$baseUrl/del/$key'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );
          debugPrint('Deleted key $key: ${deleteResponse.body}');
        }
        debugPrint('All users cleared from Upstash');
      } else {
        debugPrint('No users to clear');
      }
    } catch (e) {
      debugPrint('Error clearing users: $e');
    }
  }
} 