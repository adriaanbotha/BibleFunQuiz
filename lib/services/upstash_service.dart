import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'http_client_non_web.dart' if (dart.library.html) 'http_client_web.dart';

class UpstashService {
  static const String baseUrl = 'https://relative-bison-60370.upstash.io';
  static const String token =
      'AevSAAIjcDFkNzY3YjFiZTZhNWI0ZjlhODlkOGE3NTgyOTY3MWQyOHAxMA';

  late final http.Client _client;

  UpstashService() {
    _client = createClient();
  }

  void dispose() {
    _client.close();
  }

  Future<dynamic> sendRequest(String command, List<String> args) async {
    final encodedArgs = args.map((arg) => Uri.encodeComponent(arg)).join('/');
    final url = Uri.parse('$baseUrl/$command/$encodedArgs');
    print('Request URL: $url');

    try {
      final response = await _client.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return jsonDecode(response.body)['result'];
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to execute $command: ${response.body}');
      }
    } catch (e) {
      print('Network error in sendRequest: $e');
      print('Stack trace: ${StackTrace.current}');
      rethrow;
    }
  }

  Future<bool> userExists(String email) async {
    try {
      final result = await sendRequest('exists', ['user:$email']);
      return result == 1;
    } catch (e) {
      print('Error in userExists: $e');
      return false;
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      print('Checking if user exists: $email');
      if (await userExists(email)) {
        print('User already exists: $email');
        return null;
      }

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      print('Register - Hashed Password: $hashedPassword');
      final userKey = 'user:$email';

      print('Storing user data with hset');
      final hsetResult = await sendRequest('hset', [
        userKey,
        'email',
        email,
        'username',
        'unknown', // Default value to avoid empty field
        'password',
        hashedPassword,
        'created_at',
        DateTime.now().millisecondsSinceEpoch.toString(),
      ]);
      print('HSET Result: $hsetResult');

      final existsAfter = await userExists(email);
      print('User exists after HSET: $existsAfter');
      if (!existsAfter) {
        throw Exception('Failed to persist user data');
      }

      final token = Uuid().v4();
      print('Generated token: $token');
      final setResult =
          await sendRequest('set', ['token:$token', email, 'EX', '86400']);
      print('SET Token Result: $setResult');

      return token;
    } catch (e) {
      print('Error in register: $e');
      return null;
    }
  }

  Future<String?> login(String email, String password) async {
    final userKey = 'user:$email';
    final userData = await sendRequest('hgetall', [userKey]);
    print('Login - User Data: $userData');

    if (userData.isEmpty) {
      print('Login - User not found for $email');
      return null;
    }

    for (int i = 0; i < userData.length; i += 2) {
      print('Field: ${userData[i]}, Value: ${userData[i + 1]}');
    }

    // Correct index for password value (email: 1, username: 3, password: 3, created_at: 7)
    final storedPassword = userData[3]?.toString().trim() ??
        ''; // Changed from userData[5] to userData[3]
    final inputPasswordHash =
        sha256.convert(utf8.encode(password)).toString().trim();
    print('Login - Stored Password: $storedPassword');
    print('Login - Input Password Hash: $inputPasswordHash');
    print('Login - Are hashes equal? ${storedPassword == inputPasswordHash}');

    if (storedPassword.isEmpty || storedPassword != inputPasswordHash) {
      print('Login - Password mismatch or empty');
      return null;
    }

    final token = Uuid().v4();
    print('Generated token: $token');
    await sendRequest('set', ['token:$token', email, 'EX', '86400']);
    print('Token stored successfully');
    return token;
  }

  Future<String?> validateToken(String token) async {
    final email = await sendRequest('get', ['token:$token']);
    return email != null ? email : null;
  }

  Future<String> testConnectivity() async {
    try {
      final result = await sendRequest('set', ['test_key', 'test_value']);
      print('Test SET Result: $result');
      return result;
    } catch (e) {
      print('Test Connectivity Error: $e');
      rethrow;
    }
  }
}
