import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import '../config/upstash_config.dart';
import '../models/question.dart';

class QuestionService {
  Future<List<Question>> getQuestions() async {
    try {
      final response = await http
          .get(
            Uri.parse('${UpstashConfig.baseUrl}/questions'),
            headers: {'Authorization': 'Bearer ${UpstashConfig.apiKey}'},
          )
          .timeout(UpstashConfig.timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Question.fromJson(json)).toList();
      }
      return _getFallbackQuestions();
    } catch (e) {
      return _getFallbackQuestions();
    }
  }

  Future<List<Question>> _getFallbackQuestions() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/fallback_questions.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load fallback questions');
    }
  }
} 