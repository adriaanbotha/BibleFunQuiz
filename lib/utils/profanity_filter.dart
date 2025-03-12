class ProfanityFilter {
  static bool isValidUsername(String username) {
    // Basic validation: 3-20 characters, alphanumeric, no spaces
    final regex = RegExp(r'^[a-zA-Z0-9]{3,20}$');
    if (!regex.hasMatch(username)) {
      return false;
    }

    // Basic profanity check (extend this list as needed)
    final profanityWords = ['badword', 'inappropriate', 'offensive'];
    return !profanityWords.any((word) => username.toLowerCase().contains(word));
  }
}
