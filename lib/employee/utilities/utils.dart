bool isLetterOrNumber(String s) {
  Set<int> digits = <int>{0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  Set<String> letters = <String>{
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'x',
    'y',
    'z'
  };
  for (int i = 0; i < s.length; i++) {
    String char = s[i];
    if (!(letters.contains(char) || digits.contains(char))) {
      return false;
    }
  }
  return true;
}

String stripWhitespace(String s) {
  int leftIndex = 0;
  while (!isLetterOrNumber(s[leftIndex].toLowerCase())) {
    leftIndex++;
  }
  int rightIndex = s.length - 1;
  while (!isLetterOrNumber(s[rightIndex].toLowerCase())) {
    rightIndex--;
  }
  return s.substring(leftIndex, rightIndex + 1);
}

bool isFirstLast(String s) {
  //has identifiable first and last name
  List<String> firstAndLast = stripWhitespace(s).split(' ');
  if (firstAndLast.length != 2) {
    return false;
  }
  return true;
}

String capitalizeAndFormat(String s) {
  String util = stripWhitespace(s);
  int commaIndex = util.indexOf(',');
  if (commaIndex != -1) {
    return util;
  } else {
    int spaceIndex = util.indexOf(' ');
    return util.substring(spaceIndex + 1, util.length) +
        ", " +
        util.substring(0, spaceIndex + 1);
  }
}
