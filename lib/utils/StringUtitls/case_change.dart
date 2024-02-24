class StringUtils{

  static String snakeCaseToTitleCase(String input) {
  // Split the input string by underscores
  List<String> words = input.split('_');

  // Capitalize the first letter of each word
  for (int i = 0; i < words.length; i++) {
    String word = words[i];
    if (word.isNotEmpty) {
      words[i] = word[0].toUpperCase() + word.substring(1);
    }
  }

  // Join the words and return the result
  return words.join(' ');
}

}


