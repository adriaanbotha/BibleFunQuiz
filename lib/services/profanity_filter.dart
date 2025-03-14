class ProfanityFilter {
  // Note: This list contains common inappropriate terms and variations
  static const List<String> _profanityList = [
    // Offensive slurs and hate speech
    'n*****', 'f*****', 'r*****',
    
    // Common profanities
    'a**', 'a**hole', 'b****', 'b*****d',
    'c***', 'c**t', 'c**k', 
    'd**k', 'd**che', 'd*****s',
    'f**k', 'f*k', 'f***ing', 'f***er',
    'h***', 'h**ker',
    'p***y', 'p***k', 'p**is',
    's**t', 's***k', 's***y',
    't**t', 't***',
    'w***e', 'w**ker',
    
    // Common variations and misspellings
    'f*ck', 'fck', 'fuk', 'phuck', 'phuk',
    'sh1t', 'sh!t', 's*it',
    'b!tch', 'b1tch', 'biatch',
    
    // Compound words
    'dumb***', 'mother******',
    
    // Internet slang
    'wtf', 'stfu', 'gtfo', 'lmfao',
    
    // Mild profanities
    'damn', 'hell', 'crap',
    
    // Inappropriate terms
    'porn', 'xxx', 'sex',
    
    // Offensive religious terms
    'jesus christ', 'goddamn', 'god damn',
    
    // Common insults
    'idiot', 'stupid', 'dumb',
    'moron', 'retard', 'imbecile',
    
    // Discriminatory terms
    'nazi', 'terrorist',
  ];

  static bool containsProfanity(String text) {
    final lowercaseText = text.toLowerCase().trim();
    
    // Check for exact matches and contained words
    return _profanityList.any((word) {
      // Remove common substitutions
      final cleanText = lowercaseText
          .replaceAll('0', 'o')
          .replaceAll('1', 'i')
          .replaceAll('3', 'e')
          .replaceAll('4', 'a')
          .replaceAll('5', 's')
          .replaceAll('7', 't')
          .replaceAll('@', 'a')
          .replaceAll('\$', 's')
          .replaceAll('!', 'i');
          
      // Check if the word is contained in the text
      return cleanText.contains(word.toLowerCase()) ||
             // Check for words with spaces or special characters between letters
             word.split('').every((char) => cleanText.contains(char));
    });
  }
} 