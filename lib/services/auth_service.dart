import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/upstash_config.dart';

class AuthService {
  final SharedPreferences _prefs;
  
  AuthService(this._prefs);

  Future<bool> login(String email, String nickname) async {
    try {
      final response = await http
          .post(
            Uri.parse('${UpstashConfig.baseUrl}/login'),
            body: {'email': email, 'nickname': nickname},
            headers: {'Authorization': 'Bearer ${UpstashConfig.apiKey}'},
          )
          .timeout(UpstashConfig.timeoutDuration);

      if (response.statusCode == 200) {
        await _saveUserData(email, nickname);
        return true;
      }
      return false;
    } catch (e) {
      return _offlineLogin(email, nickname);
    }
  }

  Future<bool> _offlineLogin(String email, String nickname) async {
    final savedEmail = _prefs.getString('user_email');
    final savedNickname = _prefs.getString('user_nickname');
    return email == savedEmail && nickname == savedNickname;
  }

  Future<bool> registerUser(String email, String nickname) async {
    try {
      final response = await http
          .post(
            Uri.parse('${UpstashConfig.baseUrl}/register'),
            body: {'email': email, 'nickname': nickname},
            headers: {'Authorization': 'Bearer ${UpstashConfig.apiKey}'},
          )
          .timeout(UpstashConfig.timeoutDuration);

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<bool> kidsLogin(String pin) async {
    return pin == await _prefs.getString('kids_pin');
  }

  Future<void> _saveUserData(String email, String nickname) async {
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_nickname', nickname);
  }
} 