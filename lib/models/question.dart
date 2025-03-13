class Question {
  final String id;
  final String text;
  final List<String> options;
  final int correctAnswer;
  final String difficulty;
  final String ageGroup;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.ageGroup,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      difficulty: json['difficulty'],
      ageGroup: json['ageGroup'],
    );
  }
} 