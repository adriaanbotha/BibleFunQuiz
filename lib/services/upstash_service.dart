import 'package:http/http.dart' as http;
import 'dart:convert';
import '../globals.dart' as globals;

class UpstashService {
  static const String upstashRedisUrl = globals.upstashRedisUrl;
  static const String upstashRedisToken =
      'AevSAAIjcDFkNzY3YjFiZTZhNWI0ZjlhODlkOGE3NTgyOTY3MWQyOHAxMA';

  static Future<bool> registerUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      print('Checking if user exists: $email');
      final checkResponse = await http.get(
        Uri.parse('$upstashRedisUrl/get/user:$email'),
        headers: {'Authorization': 'Bearer $upstashRedisToken'},
      );

      print('Check user response status: ${checkResponse.statusCode}');
      print('Check user response body: ${checkResponse.body}');

      if (checkResponse.statusCode == 200) {
        final checkResult = jsonDecode(checkResponse.body);
        if (checkResult['result'] != null) {
          print('User already exists: $email');
          return false;
        }
      }

      print('Saving new user: $email');
      final userData = jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'nickname': username,
      });

      final saveResponse = await http.post(
        Uri.parse('$upstashRedisUrl/set/user:$email/$userData'),
        headers: {'Authorization': 'Bearer $upstashRedisToken'},
      );

      print('Save user response status: ${saveResponse.statusCode}');
      print('Save user response body: ${saveResponse.body}');

      if (saveResponse.statusCode == 200) {
        final saveResult = jsonDecode(saveResponse.body);
        if (saveResult['result'] == 'OK') {
          print('Successfully registered user: $email');
          return true;
        }
      }

      print(
          'Failed to register user: ${saveResponse.statusCode} - ${saveResponse.body}');
      return false;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  static Future<void> savePlayerData({
    required String username,
    required String email,
    required String authToken,
    String? nickname,
    String? password,
  }) async {
    try {
      final userData = jsonEncode({
        'username': username,
        'email': email,
        'authToken': authToken,
        'nickname': nickname ?? '',
        'password': password,
      });

      final response = await http.post(
        Uri.parse('$upstashRedisUrl/set/user:$email/$userData'),
        headers: {'Authorization': 'Bearer $upstashRedisToken'},
      );

      print('Save player data response status: ${response.statusCode}');
      print('Save player data response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] == 'OK') {
          print('Successfully saved player data to Upstash');
        } else {
          print(
              'Failed to save player data: Unexpected response - ${response.body}');
        }
      } else {
        print(
            'Failed to save player data: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error saving to Upstash: $e');
    }
  }

  static Future<Map<String, dynamic>?> loadPlayerData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$upstashRedisUrl/get/user:$email'),
        headers: {'Authorization': 'Bearer $upstashRedisToken'},
      );

      print('Load player data response status: ${response.statusCode}');
      print('Load player data response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['result'] != null) {
          return jsonDecode(result['result']);
        }
      }
      print(
          'Failed to load player data: ${response.statusCode} - ${response.body}');
      return null;
    } catch (e) {
      print('Error loading from Upstash: $e');
      return null;
    }
  }

  static Future<void> loadLeaderboard() async {
    print('Leaderboard loading not implemented yet');
  }
}
