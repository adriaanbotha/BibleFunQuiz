class ProfanityFilter {
  static const List<String> swearWords = [
    'badword1', 'badword2', 'damn', 'hell', // Add more as needed
  ];

  static bool isValidUsername(String username) {
    final lowercaseUsername = username.toLowerCase();
    return !swearWords.any((word) => lowercaseUsername.contains(word)) &&
        username.length >= 3 &&
        username.length <= 20 &&
        RegExp(r'^[a-zA-Z0-9_]+$')
            .hasMatch(username); // Alphanumeric + underscore
  }
}
