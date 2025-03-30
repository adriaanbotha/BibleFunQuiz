import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'profanity_filter.dart';
import 'package:flutter/services.dart';

class AuthService {
  final SharedPreferences _prefs;
  static const String _usersKey = 'registered_users';
  
  // Add cache keys for questions
  static const String _cachedQuestionsKey = 'cached_questions';
  static const String _questionsLastUpdatedKey = 'questions_last_updated';
  
  // Avatar List - Biblical characters
  static const List<String> avatarOptions = [
    'noah', 'moses', 'david', 'daniel', 'esther', 'ruth', 
    'abraham', 'joshua', 'solomon', 'samson', 'deborah', 'miriam'
  ];
  
  // Upstash Configuration
  static const String baseUrl = 'https://relative-bison-60370.upstash.io';
  static const String apiKey = 'AevSAAIjcDFkNzY3YjFiZTZhNWI0ZjlhODlkOGE3NTgyOTY3MWQyOHAxMA';

  AuthService(this._prefs);

  // Online Registration
  Future<bool> register(String email, String password, String nickname) async {
    debugPrint('Attempting registration with email: $email and nickname: $nickname');
    
    try {
      // Check if user exists
      final checkUserResponse = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (checkUserResponse.statusCode == 200) {
        final userData = json.decode(checkUserResponse.body);
        if (userData['result'] != null) {
          debugPrint('User already exists');
          return false;
        }

        // Create new user data with default avatar
        final user = {
          'email': email,
          'password': password,
          'nickname': nickname,
          'avatar': 'noah', // Default avatar
          'createdAt': DateTime.now().toIso8601String(),
        };

        // Store user data
        final registerResponse = await http.post(
          Uri.parse('$baseUrl/set/user:$email/${Uri.encodeComponent(json.encode(user))}'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );

        if (registerResponse.statusCode == 200) {
          debugPrint('User registered successfully');
          await _saveUserData(email, nickname);
          return true;
        }
      }
      
      debugPrint('Registration failed');
      return false;
    } catch (e) {
      debugPrint('Error during registration: $e');
      return false;
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
        'avatar': 'noah', // Default avatar
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
    
    // Get avatar if exists, otherwise set default
    final response = await http.post(
      Uri.parse('$baseUrl/get/user:$email'),
      headers: {
        'Authorization': 'Bearer $apiKey',
      },
    );
    
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      if (userData['result'] != null) {
        final user = json.decode(userData['result']);
        if (user['avatar'] != null) {
          await _prefs.setString('current_user_avatar', user['avatar']);
          return;
        }
      }
    }
    
    // Set default if not found
    await _prefs.setString('current_user_avatar', 'noah');
  }

  Future<void> logout() async {
    await _prefs.remove('current_user_email');
    await _prefs.remove('current_user_nickname');
  }

  Future<bool> isLoggedIn() async {
    // Check if user is logged in (e.g., by checking for a stored token or user data)
    // Return true if logged in, false otherwise
    final email = await getCurrentUserEmail();
    return email != null && email.isNotEmpty;
  }

  Future<String?> getCurrentUserEmail() async {
    // Return the email of the currently logged in user, or null if not logged in
    // This will depend on how you're storing the user's login state
    return _prefs.getString('current_user_email');
  }

  String? getNickname() {
    return _prefs.getString('current_user_nickname');
  }

  String? getAvatar() {
    return _prefs.getString('current_user_avatar') ?? 'noah';
  }
  
  List<String> getAvatarOptions() {
    return avatarOptions;
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

  Future<bool> updateNickname(String email, String newNickname) async {
    try {
      // Check for profanity
      if (ProfanityFilter.containsProfanity(newNickname)) {
        debugPrint('Nickname contains inappropriate content');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (userData['result'] != null) {
          final user = json.decode(userData['result']);
          user['nickname'] = newNickname;

          // Update user data in Upstash
          final updateResponse = await http.post(
            Uri.parse('$baseUrl/set/user:$email/${json.encode(user)}'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (updateResponse.statusCode == 200) {
            await _saveUserData(email, newNickname);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating nickname: $e');
      return false;
    }
  }

  String? getCurrentEmail() {
    return _prefs.getString('current_user_email');
  }

  Future<bool> loadQuestionsToUpstash() async {
    try {
      // Load questions from asset
      final String jsonString = await rootBundle.loadString('assets/questions.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Get questions for each difficulty level
      final childrenQuestions = jsonData['children'] as List<dynamic>;
      final beginnerQuestions = jsonData['beginner'] as List<dynamic>;
      final intermediateQuestions = jsonData['intermediate'] as List<dynamic>;
      final advancedQuestions = jsonData['advanced'] as List<dynamic>;
      
      debugPrint('Loading questions to Upstash...');
      debugPrint('Children\'s: ${childrenQuestions.length}');
      debugPrint('Beginner: ${beginnerQuestions.length}');
      debugPrint('Intermediate: ${intermediateQuestions.length}');
      debugPrint('Advanced: ${advancedQuestions.length}');

      // Store questions by difficulty
      await _storeQuestionsByDifficulty('children', childrenQuestions);
      await _storeQuestionsByDifficulty('beginner', beginnerQuestions);
      await _storeQuestionsByDifficulty('intermediate', intermediateQuestions);
      await _storeQuestionsByDifficulty('advanced', advancedQuestions);

      // Store the total counts
      final countResponse = await http.post(
        Uri.parse('$baseUrl/mset/questions:children:count/${childrenQuestions.length}/questions:beginner:count/${beginnerQuestions.length}/questions:intermediate:count/${intermediateQuestions.length}/questions:advanced:count/${advancedQuestions.length}'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (countResponse.statusCode != 200) {
        debugPrint('Failed to store question counts: ${countResponse.body}');
        return false;
      }

      debugPrint('Successfully loaded all questions to Upstash');
      return true;
    } catch (e) {
      debugPrint('Error loading questions: $e');
      return false;
    }
  }

  Future<bool> _storeQuestionsByDifficulty(String difficulty, List<dynamic> questions) async {
    try {
      for (int i = 0; i < questions.length; i++) {
        final questionJson = json.encode(questions[i]);
        debugPrint('Storing $difficulty question $i');

        final response = await http.post(
          Uri.parse('$baseUrl/set/question:$difficulty:$i/${Uri.encodeComponent(questionJson)}'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );
        
        if (response.statusCode != 200) {
          debugPrint('Failed to store $difficulty question $i: ${response.body}');
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error storing $difficulty questions: $e');
      return false;
    }
  }

  Future<void> listQuestions() async {
    try {
      final difficulties = ['beginner', 'intermediate', 'advanced'];
      
      for (final difficulty in difficulties) {
        // Get count for this difficulty
        final countResponse = await http.post(
          Uri.parse('$baseUrl/get/questions:$difficulty:count'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );

        if (countResponse.statusCode == 200) {
          final count = int.parse(json.decode(countResponse.body)['result']);
          debugPrint('\n$difficulty Questions (Total: $count):');

          // List questions for this difficulty
          for (int i = 0; i < count; i++) {
            final response = await http.post(
              Uri.parse('$baseUrl/get/question:$difficulty:$i'),
              headers: {
                'Authorization': 'Bearer $apiKey',
              },
            );

            if (response.statusCode == 200) {
              final question = json.decode(response.body)['result'];
              debugPrint('Question $i: $question');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error listing questions: $e');
    }
  }

  Future<bool> clearQuestions() async {
    try {
      final difficulties = ['children', 'beginner', 'intermediate', 'advanced'];
      
      for (final difficulty in difficulties) {
        // Get count for this difficulty
        final countResponse = await http.post(
          Uri.parse('$baseUrl/get/questions:$difficulty:count'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );

        if (countResponse.statusCode == 200) {
          final count = int.parse(json.decode(countResponse.body)['result']);
          
          // Delete all questions for this difficulty
          for (int i = 0; i < count; i++) {
            await http.post(
              Uri.parse('$baseUrl/del/question:$difficulty:$i'),
              headers: {
                'Authorization': 'Bearer $apiKey',
              },
            );
          }

          // Delete the count
          await http.post(
            Uri.parse('$baseUrl/del/questions:$difficulty:count'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );
        }
      }

      debugPrint('Successfully cleared all questions');
      return true;
    } catch (e) {
      debugPrint('Error clearing questions: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      // Get the total count first
      final countResponse = await http.post(
        Uri.parse('$baseUrl/get/questions:count'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (countResponse.statusCode != 200) {
        throw Exception('Failed to get question count');
      }

      final count = int.parse(json.decode(countResponse.body)['result']);
      final questions = <Map<String, dynamic>>[];

      // Get all questions
      for (int i = 0; i < count; i++) {
        final response = await http.post(
          Uri.parse('$baseUrl/get/question:$i'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );

        if (response.statusCode == 200) {
          final questionJson = json.decode(response.body)['result'];
          questions.add(json.decode(questionJson));
        }
      }

      return questions;
    } catch (e) {
      debugPrint('Error getting questions: $e');
      return [];
    }
  }

  Future<void> listUsers() async {
    try {
      // Get all keys that start with 'user:'
      final response = await http.post(
        Uri.parse('$baseUrl/keys/user:*'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final keys = json.decode(response.body)['result'] as List<dynamic>;
        debugPrint('Found ${keys.length} users');

        // Get details for each user
        for (String key in keys) {
          final userResponse = await http.post(
            Uri.parse('$baseUrl/get/$key'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (userResponse.statusCode == 200) {
            final userData = json.decode(userResponse.body)['result'];
            if (userData != null) {
              final user = json.decode(userData);
              debugPrint('User: ${user['email']}, Nickname: ${user['nickname']}');
            }
          }
        }
      } else {
        debugPrint('Failed to list users: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error listing users: $e');
    }
  }

  Future<bool> clearUsers() async {
    try {
      // Get all keys that start with 'user:'
      final response = await http.post(
        Uri.parse('$baseUrl/keys/user:*'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final keys = json.decode(response.body)['result'] as List<dynamic>;
        debugPrint('Deleting ${keys.length} users');

        // Delete each user
        for (String key in keys) {
          final deleteResponse = await http.post(
            Uri.parse('$baseUrl/del/$key'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (deleteResponse.statusCode != 200) {
            debugPrint('Failed to delete user $key: ${deleteResponse.body}');
          }
        }

        debugPrint('Successfully cleared all users');
        return true;
      }
      debugPrint('Failed to get user keys: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('Error clearing users: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getQuestionsByDifficulty(String difficulty) async {
    try {
      // Try to get cached questions first
      final cachedQuestions = await _getCachedQuestions(difficulty);
      if (cachedQuestions.isNotEmpty) {
        return cachedQuestions;
      }

      // If no cached questions, fetch from server
      final questions = await _fetchQuestionsFromServer(difficulty);
      if (questions.isNotEmpty) {
        await _cacheQuestions(difficulty, questions);
      }
      return questions;
    } catch (e) {
      debugPrint('Error getting questions by difficulty: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getCachedQuestions(String difficulty) async {
    try {
      final cachedData = _prefs.getString('${_cachedQuestionsKey}_$difficulty');
      if (cachedData != null) {
        final lastUpdated = _prefs.getInt('${_questionsLastUpdatedKey}_$difficulty') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Check if cache is less than 24 hours old
        if (now - lastUpdated < 24 * 60 * 60 * 1000) {
          final List<dynamic> questions = json.decode(cachedData);
          return questions.map((q) => Map<String, dynamic>.from(q)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error reading cached questions: $e');
      return [];
    }
  }

  Future<void> _cacheQuestions(String difficulty, List<Map<String, dynamic>> questions) async {
    try {
      await _prefs.setString('${_cachedQuestionsKey}_$difficulty', json.encode(questions));
      await _prefs.setInt(
        '${_questionsLastUpdatedKey}_$difficulty',
        DateTime.now().millisecondsSinceEpoch
      );
    } catch (e) {
      debugPrint('Error caching questions: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchQuestionsFromServer(String difficulty) async {
    try {
      // Get count for this difficulty
      final countResponse = await http.post(
        Uri.parse('$baseUrl/get/questions:$difficulty:count'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (countResponse.statusCode != 200) {
        throw Exception('Failed to get question count');
      }

      final count = int.parse(json.decode(countResponse.body)['result']);
      final questions = <Map<String, dynamic>>[];

      // Get all questions for this difficulty
      for (int i = 0; i < count; i++) {
        final response = await http.post(
          Uri.parse('$baseUrl/get/question:$difficulty:$i'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );

        if (response.statusCode == 200) {
          final questionJson = json.decode(response.body)['result'];
          if (questionJson != null) {
            questions.add(json.decode(questionJson));
          }
        }
      }

      return questions;
    } catch (e) {
      debugPrint('Error fetching questions from server: $e');
      return [];
    }
  }

  // Add method to force refresh cache
  Future<bool> refreshQuestionCache() async {
    try {
      final difficulties = ['children', 'beginner', 'intermediate', 'advanced'];
      for (final difficulty in difficulties) {
        final questions = await _fetchQuestionsFromServer(difficulty);
        if (questions.isNotEmpty) {
          await _cacheQuestions(difficulty, questions);
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error refreshing question cache: $e');
      return false;
    }
  }

  // Add method to clear cache
  Future<void> clearQuestionCache() async {
    final difficulties = ['children', 'beginner', 'intermediate', 'advanced'];
    for (final difficulty in difficulties) {
      await _prefs.remove('${_cachedQuestionsKey}_$difficulty');
      await _prefs.remove('${_questionsLastUpdatedKey}_$difficulty');
    }
  }

  Future<void> updateUserStats(String email, int score, String difficulty) async {
    try {
      // Get current user data
      final response = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['result'];
        if (userData != null) {
          final user = json.decode(userData);
          
          // Initialize or update statistics
          if (user['statistics'] == null) {
            user['statistics'] = {
              'totalQuizzes': 0,
              'totalScore': 0,
              'quizzesByDifficulty': {
                'beginner': 0,
                'intermediate': 0,
                'advanced': 0,
              },
              'scoresByDifficulty': {
                'beginner': 0,
                'intermediate': 0,
                'advanced': 0,
              },
            };
          }

          // Update statistics
          user['statistics']['totalQuizzes'] = (user['statistics']['totalQuizzes'] ?? 0) + 1;
          user['statistics']['totalScore'] = (user['statistics']['totalScore'] ?? 0) + score;
          user['statistics']['quizzesByDifficulty'][difficulty] = 
              (user['statistics']['quizzesByDifficulty'][difficulty] ?? 0) + 1;
          user['statistics']['scoresByDifficulty'][difficulty] = 
              (user['statistics']['scoresByDifficulty'][difficulty] ?? 0) + score;

          // Update user data
          final updateResponse = await http.post(
            Uri.parse('$baseUrl/set/user:$email/${Uri.encodeComponent(json.encode(user))}'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (updateResponse.statusCode == 200) {
            await this.updateLeaderboard(email, user['nickname'] ?? email, score, difficulty);
          }
        }
      }
    } catch (e) {
      debugPrint('Error updating user stats: $e');
    }
  }

  Future<void> updateLeaderboard(String email, String nickname, int score, String difficulty) async {
    try {
      // Get current leaderboard
      final response = await http.post(
        Uri.parse('$baseUrl/get/leaderboard:$difficulty'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      List<Map<String, dynamic>> leaderboard = [];
      if (response.statusCode == 200 && json.decode(response.body)['result'] != null) {
        leaderboard = List<Map<String, dynamic>>.from(
          json.decode(json.decode(response.body)['result'])
        );
      }

      // Get user's avatar
      String avatar = 'noah'; // Default avatar
      final userResponse = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );
      
      if (userResponse.statusCode == 200 && json.decode(userResponse.body)['result'] != null) {
        final userData = json.decode(json.decode(userResponse.body)['result']);
        avatar = userData['avatar'] ?? 'noah';
      }

      // Add new score with avatar information
      leaderboard.add({
        'email': email,
        'nickname': nickname,
        'avatar': avatar,
        'score': score,
        'date': DateTime.now().toIso8601String(),
      });

      // Sort by score (descending) and take top 100
      leaderboard.sort((a, b) => b['score'].compareTo(a['score']));
      if (leaderboard.length > 100) {
        leaderboard = leaderboard.sublist(0, 100);
      }

      // Update leaderboard
      await http.post(
        Uri.parse('$baseUrl/set/leaderboard:$difficulty/${Uri.encodeComponent(json.encode(leaderboard))}'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );
    } catch (e) {
      debugPrint('Error updating leaderboard: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard(String difficulty) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/leaderboard:$difficulty'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200 && json.decode(response.body)['result'] != null) {
        return List<Map<String, dynamic>>.from(
          json.decode(json.decode(response.body)['result'])
        );
      }
      return [];
    } catch (e) {
      debugPrint('Error getting leaderboard: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> getUserStats(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['result'];
        if (userData != null) {
          final user = json.decode(userData);
          return user['statistics'] ?? {
            'totalQuizzes': 0,
            'totalScore': 0,
            'quizzesByDifficulty': {
              'beginner': 0,
              'intermediate': 0,
              'advanced': 0,
            },
            'scoresByDifficulty': {
              'beginner': 0,
              'intermediate': 0,
              'advanced': 0,
            },
          };
        }
      }
      return {};
    } catch (e) {
      debugPrint('Error getting user stats: $e');
      return {};
    }
  }

  Future<bool> clearLeaderboards() async {
    try {
      final difficulties = ['children', 'beginner', 'intermediate', 'advanced'];
      for (final difficulty in difficulties) {
        await http.post(
          Uri.parse('$baseUrl/del/leaderboard:$difficulty'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );
      }
      return true;
    } catch (e) {
      debugPrint('Error clearing leaderboards: $e');
      return false;
    }
  }

  // Clear the leaderboard
  Future<void> clearLeaderboard() async {
    try {
      // Clear leaderboards for all difficulties
      final difficulties = ['children', 'beginner', 'intermediate', 'advanced'];
      for (final difficulty in difficulties) {
        await http.post(
          Uri.parse('$baseUrl/del/leaderboard:$difficulty'),
          headers: {
            'Authorization': 'Bearer $apiKey',
          },
        );
      }
      debugPrint('Leaderboard cleared successfully');
    } catch (e) {
      debugPrint('Error clearing leaderboard: $e');
      throw e;
    }
  }

  // Get player's position in leaderboard
  Future<int> getPlayerLeaderboardPosition(String nickname) async {
    try {
      final leaderboard = await getLeaderboard('beginner');
      if (leaderboard == null) return -1;
      
      for (int i = 0; i < leaderboard.length; i++) {
        if (leaderboard[i]['nickname'] == nickname) {
          return i;
        }
      }
      return -1; // Player not found
    } catch (e) {
      debugPrint('Error getting player position: $e');
      return -1;
    }
  }

  // Update statistics
  Future<void> updateStatistics(String email, int correctAnswers, int totalQuestions, int score) async {
    try {
      // Get current user data
      final userData = await getUserStats(email);
      if (userData == null) return;
      
      // Update statistics
      final stats = userData['statistics'] ?? {};
      stats['totalQuizzes'] = (stats['totalQuizzes'] ?? 0) + 1;
      stats['totalQuestions'] = (stats['totalQuestions'] ?? 0) + totalQuestions;
      stats['correctAnswers'] = (stats['correctAnswers'] ?? 0) + correctAnswers;
      stats['totalScore'] = (stats['totalScore'] ?? 0) + score;
      
      // Save updated stats
      await updateUserStats(email, score, 'beginner');
      
      print('Statistics updated successfully');
    } catch (e) {
      print('Error updating statistics: $e');
    }
  }

  // Add this method if it doesn't exist
  Map<String, dynamic>? getCurrentUser() {
    return null;
  }

  // Add public method to check if questions are cached
  Future<bool> hasQuestionsInCache(String difficulty) async {
    try {
      final cachedData = _prefs.getString('${_cachedQuestionsKey}_$difficulty');
      if (cachedData != null) {
        final lastUpdated = _prefs.getInt('${_questionsLastUpdatedKey}_$difficulty') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Check if cache is less than 24 hours old
        if (now - lastUpdated < 24 * 60 * 60 * 1000) {
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking cached questions: $e');
      return false;
    }
  }

  // Add feedback to the database
  Future<bool> submitFeedback(String feedback, {String? email}) async {
    try {
      final feedbackData = {
        'feedback': feedback,
        'email': email ?? getCurrentEmail() ?? 'anonymous',
        'timestamp': DateTime.now().toIso8601String(),
        'nickname': getNickname() ?? 'Anonymous User',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/lpush/feedback/${Uri.encodeComponent(json.encode(feedbackData))}'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error submitting feedback: $e');
      return false;
    }
  }

  // Get all feedback (admin only)
  Future<List<Map<String, dynamic>>> getAllFeedback() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lrange/feedback/0/-1'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['result'] != null) {
          return (result['result'] as List)
              .map((item) => json.decode(item) as Map<String, dynamic>)
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error getting feedback: $e');
      return [];
    }
  }

  Future<bool> updateAvatar(String email, String newAvatar) async {
    try {
      // Check if avatar is valid
      if (!avatarOptions.contains(newAvatar)) {
        debugPrint('Invalid avatar selection');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/get/user:$email'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        if (userData['result'] != null) {
          final user = json.decode(userData['result']);
          user['avatar'] = newAvatar;

          // Update user data in Upstash
          final updateResponse = await http.post(
            Uri.parse('$baseUrl/set/user:$email/${json.encode(user)}'),
            headers: {
              'Authorization': 'Bearer $apiKey',
            },
          );

          if (updateResponse.statusCode == 200) {
            await _prefs.setString('current_user_avatar', newAvatar);
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error updating avatar: $e');
      return false;
    }
  }
} 